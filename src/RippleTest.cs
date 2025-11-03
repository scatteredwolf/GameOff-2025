using Godot;
using System;
using System.Reflection;


public partial class RippleTest : ColorRect
{
    [Export]
    ColorRect tileMap;

    public override void _Ready()
    {
        base._Ready();
        (tileMap.Material as ShaderMaterial).SetShaderParameter("ripple_origin", new Vector2(0, 0));
        (tileMap.Material as ShaderMaterial).SetShaderParameter("ripple_radius", 0.0);

    }

    void On_button_down(InputEvent @event)
    {
        if (@event is InputEventMouseButton mb)
        {
            Vector2 local_pos = (mb.Position - GlobalPosition) / Size;
            (tileMap.Material as ShaderMaterial).SetShaderParameter("ripple_origin", local_pos);
            ripple_effect();
            //(tileMap.Material as ShaderMaterial).SetShaderParameter("active", 1.0);
        }
    }
    void ripple_effect()
    {
        Tween tween = GetTree().CreateTween();
        Callable cb = Callable.From<float>((float value) =>
        {
            var mat = tileMap.Material as ShaderMaterial;
            mat.SetShaderParameter("ripple_radius", value / 50.0);
        });
        tween.TweenMethod(cb, 0.0, 150.0, 1.5);
    }
}
