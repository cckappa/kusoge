@tool
extends Control

@export_tool_button("Emit Particles")
var emit_particles_button: = emit_particles

func emit_particles() -> void:
	for particle in get_children():
		if particle is CPUParticles2D:
			particle.emitting = true
