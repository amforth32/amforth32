# SPDX-License-Identifier: GPL-3.0-only

# -----------------------------------------------------------------------------
  CODEWORD  "depth", DEPTH /* ( -- n ) n is current dept of the data stack */
# -----------------------------------------------------------------------------
  # Berechne den Stackfüllstand
  la t0, RAM_upper_datastack # Anfang laden  Calculate stack fill gauge
  sub t0, t0, s4            # und aktuellen Stackpointer abziehen
  savetos
  srai s3, t0, 2 # Durch 4 teilen  Divide through 4 Bytes/element.
  NEXT
END DEPTH

# -----------------------------------------------------------------------------
  CODEWORD  "rdepth", RDEPTH /* ( -- n ) n is current dept of the return stack */
# -----------------------------------------------------------------------------
  # Berechne den Stackfüllstand
  la t0, RAM_upper_returnstack # Anfang laden  Calculate stack fill gauge
  sub t0, t0, s5          # und aktuellen Stackpointer abziehen
  savetos
  srai s3, t0, 2 # Durch 4 teilen  Divide through 4 Bytes/element.
  NEXT
END RDEPTH

#------------------------------------------------------------------------------
  CODEWORD  "rdrop", RDROP /* (R: x -- ) drop top of the return stack */
#------------------------------------------------------------------------------
  addi s5, s5, 4
  NEXT
END RDROP
