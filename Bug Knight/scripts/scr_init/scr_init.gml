function init_breakable_types() {
    /// @description Define all breakable drop configurations
    /// Add new types here — reference by string key in room Creation Code
    
    global.breakable_types = {
        
        "crate_soul" : {
            drops: [
                { type: "soul",   count: 2 },
            ]
        },
        
        "crate_health" : {
            drops: [
                { type: "health", count: 1 },
            ]
        },
        
        "crate_mixed" : {
            drops: [
                { type: "soul",   count: 2 },
                { type: "health", count: 1 },
            ]
        },
        
        "crate_rich" : {
            drops: [
                { type: "soul",   count: 4 },
                { type: "health", count: 2 },
            ]
        }
    };
}

function transition_to(room_id) {
    /// @description Triggers a fade out then room change
    if !instance_exists(obj_transition) {
        instance_create_layer(0, 0, "Instances", obj_transition);
    }
    obj_transition.target_room  = room_id;
    obj_transition.fading_out   = true;
    obj_transition.fading_in    = false;
}