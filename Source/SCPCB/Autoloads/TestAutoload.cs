using Godot;

namespace SCPCB.Autoloads
{
    public partial class TestAutoload : Node
    {
        public override void _EnterTree() => GD.Print("Hello from .NET!");
    }
}