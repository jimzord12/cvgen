// The Workflow Model's types (ADR 0015): one Zod definition per entity, the
// single source for the TypeScript types and the exported JSON Schema.
//
// Shape only. Every `...Ref` below is an ID that must name an entity defined
// somewhere in the model; whether it does (and whether IDs are unique, step
// IDs start with their stage's ID, and so on) is checked over the whole
// model by the workflow tool's `check` (TASK-38), not here.
import { z } from "zod";

// --- IDs: stable kebab-case, with a kind prefix where the handoff gives one.

const kebab = "[a-z][a-z0-9]*(?:-[a-z0-9]+)*";
// `patternErrorMessage` carries the same message into the JSON Schema, so the
// VS Code YAML extension shows it instead of the raw pattern.
const id = (prefix: string, example: string, error = `must be a kebab-case ID like "${example}"`) =>
  z
    .string()
    .regex(new RegExp(`^${prefix}${kebab}$`), { error })
    .meta({ description: `ID, kebab-case, e.g. ${example}`, patternErrorMessage: error });

export const ActionKinds = ["cmd", "skill", "agent", "manual", "lead"] as const;
// The prefixes the other IDs use; a stage may not be named after one.
const reserved = `(?:art|actor|gate|loop|${ActionKinds.join("|")})`;
const notReserved = `may not be one of the ID prefixes art, actor, gate, loop, ${ActionKinds.join(", ")}`;
export const StageId = id(`(?!${reserved}$)`, "intake", `must be a kebab-case ID like "intake" that ${notReserved}`);
export const StepId = id(
  `(?!${reserved}\\.)${kebab}\\.`,
  "intake.relay-send",
  `must be "<stage>.<name>" in kebab-case, like "intake.relay-send"; the stage part ${notReserved}`,
);
export const ArtifactId = id("art\\.", "art.envelope-json");
export const ActorId = id("actor\\.", "actor.owner");
export const GateId = id("gate\\.", "gate.sign-off");
export const LoopId = id("loop\\.", "loop.deep-dive-review");
export const ActionId = id(
  `(?:${ActionKinds.join("|")})\\.`,
  "cmd.cv-approve",
  `must be "<kind>.<name>" with kind ${ActionKinds.join(", ")}, e.g. "cmd.cv-approve"`,
);

// References: the same shapes, named for what they point at (TASK-38 resolves them).
export const StageRef = StageId;
export const StepRef = StepId;
export const ArtifactRef = ArtifactId;
export const ActorRef = ActorId;
export const GateRef = GateId;
export const ActionRef = ActionId;

/**
 * Where a fact comes from: `path`, `path:12` or `path:12-30`, repo-relative.
 * A path may contain spaces (backlog task files do), not a colon. A reversed
 * range is refused by the workflow tool only: JSON Schema cannot compare numbers in a string.
 */
const sourceError = 'must be "path", "path:12" or "path:12-30"';
export const Source = z
  .string()
  .regex(/^[^\s:](?:[^:]*[^\s:])?(?::\d+(?:-\d+)?)?$/, { error: sourceError })
  .refine(
    (s) => {
      const range = /:(\d+)-(\d+)$/.exec(s);
      return !range || Number(range[1]) <= Number(range[2]);
    },
    { error: "range runs backwards: write the lower line first, as path:12-30" },
  )
  .meta({ description: "Source anchor: path, path:12 or path:12-30", patternErrorMessage: sourceError });

// Every entity has an ID, a short human name and at least one source anchor.
const base = {
  name: z.string().min(1).meta({ description: "Short human name" }),
  sources: z.array(Source).min(1).meta({ description: "Where this fact is written today" }),
};

// --- Actor: who acts.

export const Actor = z.strictObject({
  id: ActorId,
  ...base,
  kind: z.enum(["human", "lead", "agent", "script"]).meta({
    description: "human (owner, client), lead (the main Claude Code session), agent (a subagent), script",
  }),
  does: z.string().min(1).meta({ description: "What this actor may do in the workflow" }),
});

// --- Action: how a step is done. The ID prefix names the kind (cmd.x is a cmd).

const action = <K extends (typeof ActionKinds)[number], S extends z.ZodRawShape>(kind: K, extra: S) =>
  z.strictObject({
    id: id(`${kind}\\.`, `${kind}.example`),
    kind: z.literal(kind),
    ...base,
    ...extra,
  });

export const Action = z.discriminatedUnion("kind", [
  action("cmd", {
    run: z.string().min(1).meta({ description: "The exact command line, placeholders in <angle brackets>" }),
  }),
  action("skill", {
    skill: z.string().regex(new RegExp(`^${kebab}$`)).meta({ description: "Folder name under .claude/skills/" }),
  }),
  action("agent", {
    agent: z.string().regex(new RegExp(`^${kebab}$`)).meta({
      description: "Agent name: a file under .claude/agents/ or a built-in such as general-purpose",
    }),
  }),
  action("manual", {
    does: z.string().min(1).meta({ description: "The human act, in one sentence" }),
  }),
  action("lead", {
    does: z.string().min(1).meta({ description: "The lead's own work, in one sentence" }),
  }),
], { error: `kind must be one of ${ActionKinds.join(", ")}` });

// --- Artifact: what flows between steps.

export const Artifact = z.strictObject({
  id: ArtifactId,
  ...base,
  path: z.string().min(1).optional().meta({
    description: "Path pattern, e.g. private/<envelope>/envelope.json; none for a chat message",
  }),
  format: z.string().min(1).optional().meta({ description: "e.g. JSON, Markdown, PDF, chat message" }),
  schema: ArtifactRef.optional().meta({ description: "The artifact holding its JSON Schema, if any" }),
  visibility: z.enum(["public", "private", "third-party", "ephemeral"]).meta({
    description:
      "public: tracked in Git; private: under private/; third-party: lives with another service (Google, the chat app, so a chat message too); ephemeral: saved nowhere (text in a Claude Code session)",
  }),
  given: z.boolean().default(false).meta({
    description: "Given to the workflow: no step produces it (a repo file, the client's first message)",
  }),
});

// --- Gate: a check with two branches.

export const Gate = z.strictObject({
  id: GateId,
  ...base,
  check: z.string().min(1).meta({ description: "What is checked, in one sentence" }),
  pass: StepRef.meta({ description: "The step that follows when the check passes" }),
  fail: StepRef.meta({ description: "The step that follows when it fails" }),
});

// --- Loop: the only allowed cycle, declared with its round cap.

export const Loop = z.strictObject({
  id: LoopId,
  ...base,
  gate: GateRef.meta({ description: "The gate whose fail branch goes back and closes the cycle" }),
  cap: z.strictObject({
    attended: z.int().positive().meta({ description: "Rounds allowed with the owner present" }),
    unattended: z.int().positive().optional().meta({ description: "Rounds allowed unattended, if different" }),
  }),
  escalate: StepRef.meta({ description: "The step taken when the cap is reached" }),
});

// --- Step: one actor doing one action, from inputs to outputs.
// Edges are never written: a step that lists another step's output as an input follows it.

export const Step = z.strictObject({
  id: StepId,
  ...base,
  actor: ActorRef,
  action: ActionRef,
  inputs: z.array(ArtifactRef).default([]),
  outputs: z.array(ArtifactRef).default([]),
  gate: GateRef.optional().meta({ description: "The gate checked when this step ends" }),
  when: z.string().min(1).optional().meta({ description: "Condition for an optional step; absent means always" }),
});

// --- Stage: one folder docs/workflow/NN-<stage>/, one stage.yaml.

export const Stage = z
  .strictObject({
    id: StageId,
    ...base,
    purpose: z.string().min(1),
    entry: z.string().min(1).meta({ description: "What must be true before the stage starts" }),
    exit: z.string().min(1).meta({ description: "What is true when it ends" }),
    steps: z.array(Step).min(1),
    gates: z.array(Gate).default([]),
    loops: z.array(Loop).default([]),
    artifacts: z.array(Artifact).default([]).meta({ description: "Artifacts used only in this stage" }),
    actions: z.array(Action).default([]).meta({ description: "Actions used only in this stage" }),
  })
  .meta({ title: "CVgen workflow stage", description: "One stage of the Workflow Model (docs/workflow/NN-<stage>/stage.yaml)" });

// --- Catalog: docs/workflow/catalog.yaml, the entities every stage shares.

export const Catalog = z
  .strictObject({
    actors: z.array(Actor).min(1),
    actions: z.array(Action).default([]),
    artifacts: z.array(Artifact).default([]),
  })
  .meta({ title: "CVgen workflow catalog", description: "Actors, actions and artifacts shared by all stages (docs/workflow/catalog.yaml)" });

export type Actor = z.output<typeof Actor>;
export type Action = z.output<typeof Action>;
export type Artifact = z.output<typeof Artifact>;
export type Gate = z.output<typeof Gate>;
export type Loop = z.output<typeof Loop>;
export type Step = z.output<typeof Step>;
export type Stage = z.output<typeof Stage>;
export type Catalog = z.output<typeof Catalog>;
