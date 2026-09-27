// plugin-udev's OWN self-contained CUE schema — the SINGLE SOURCE for this
// plugin's declaration surface, used two ways exactly like every other plugin's
// schema (there is no schema-less plugin):
//
//  1. GENERATE the Go params — `cue exp gengotypes` → ../params/cue_types_gen.go.
//  2. SERVE over Describe — the host splices `base ++ plugin` at the load gate
//     (registerPluginUnitSchema), so the plugin's declarations travel WITH it and
//     a self-contained schema that will not splice is a LOUD load failure.
//
// `command:udev` is CLI-dispatched (syscall.Exec), not resolved through the gRPC
// provider registry, so the provider advertises NO gRPC capability — this schema
// DOCUMENTS the command contract + the udev-rule manager's subcommands and
// satisfies the uniform non-empty-schema contract. SELF-CONTAINED: it references
// no base def, so it compiles STANDALONE (the property `cue exp gengotypes` needs
// and the property that lets the SDK compile it serve-side).
#UdevPlugin: {
	// The command word the plugin serves.
	command: "udev"

	// What the command does, in one line (the public-docs surface).
	contract: string & !=""

	// The declared subcommands of the `charly udev` word (the Kong grammar).
	subcommands?: [...string]

	// The configuration surface: env var names the rule writer reads.
	config?: [string]: string
}
