# This is a template to start from.
# Copy it into your mcu/ directory and modify as needed.

.text
.global PFA_COLD
  j PFA_COLD

.include "config.inc"
.include "build-config.inc"
.include "rv/macros.inc"
.include "user.inc"

.section amforth, "ax"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT
