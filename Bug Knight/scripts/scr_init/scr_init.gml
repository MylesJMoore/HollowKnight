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