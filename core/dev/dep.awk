# Normalize file paths in build/amforth.dep
# to be shortest $AMFORTH relative paths

function normalize(path) {
    # drop ./ prefix if present
    sub(/^\.\//, "", path)
    # make path absolute
    path = (path ~ /^\//) ? path : ENVIRON["PWD"] "/" path
    # remove intermediate /../
    do {
        old_path = path;
        # Use gsub to replace all occurrences in the current string
        # gsub modifies target_str in place and returns the number of substitutions
        gsub(/\/[^\/]+\/\.\.\//, "/", path);
    } while (path != old_path); # Continue looping as long as a substitution occurred
    # make path relative to $AMFORTH
    sub(ENVIRON["AMFORTH"] "/", "", path)
    return path;
}

{ print normalize($0) }