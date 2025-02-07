using Godot;
using System;

public partial class Player : CharacterBody3D
{
/*
	// Animation player ready
	private AnimationPlayer anim;

	public override void _Ready() {
		anim = GetNode<AnimationPlayer>("Visual/AnimationPlayer");
	}

	//

	private Node GLOBAL = GetNode<Node>("/root/GLOBALS");

	//[Export]
	//private Inventory inventory;
	public const float SPEED = 5.0f;
	public const float JUMP_FORCE_BASE = 4.5f;
	
	public float jumpTime = 0.0f;

	public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("jump") && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
		}

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 inputDir = Input.GetVector("move_left", "move_right", "move_up", "move_down");
		Vector3 direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Z = direction.Z * Speed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Z = Mathf.MoveToward(Velocity.Z, 0, Speed);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
	*/
}
