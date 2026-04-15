BEGIN { pass = 0; fail = 0; finished = 0; unknown = 0 } 
/\|TESTS FINISHED/ { finished = 1 } 
/\|TESTING / { print } 
/\|HARDWARE_.* / { print } 
/\|T\{.*\}T/ { marker=$0; next }
/^[[:space:]]*$/ { next }
marker { 
    if ($0 ~ / \?\? |INCORRECT RESULT|WRONG NUMBER/) { 
            fail += 1 ; print marker; print $0 
    } else if ($0 ~ /\|PASS/) { 
        pass += 1 
    } else { 
        unknown += 1 
    }
    marker="" } 
END { 
    printf "FINISHED: %s, PASS: %d, FAIL: %d, UNKNOWN: %d\n", finished ? "Y" : "N", pass, fail, unknown; 
    if (!finished || fail > 0 || unknown > 0) exit 1 
}
