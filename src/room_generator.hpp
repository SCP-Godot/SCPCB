#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/binder_common.hpp>

using namespace godot;

class RoomGenerator : public Node
{
    GDCLASS(RoomGenerator, Node)

public:
    RoomGenerator();
    ~RoomGenerator();

    static void _bind_methods() {}
};