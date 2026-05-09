function approach(val, target, amount) {
    if val < target {
        return min(val + amount, target);
    } else {
        return max(val - amount, target);
    }
}