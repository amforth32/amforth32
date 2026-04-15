# SPDX-License-Identifier: GPL-3.0-only
#
# all secondaries / colon words
#

.include "words/flash-common.s"
.include "words/flash.s"
.include "words/warm.s"
.include "words/first-boot.s"

.include "words/quit.s"
.include "words/interpret.s"

.include "words/recognize.s"
.include "words/rec-null.s"
.include "words/rec-find.s"
.include "words/rec-intnum.s"
.include "words/rec-split.s"
.include "words/forth-recognizer.s"

# these move from pri-
.include "words/dabs.s"
.include "words/base.s"
.include "words/state.s"
.include "words/key.s"
.include "words/keyq.s"
.include "words/emit.s"
.include "words/emitq.s"

.include "words/pause.s"
.include "words/bounds.s"
.include "words/do-sliteral.s"
# end move

.include "words/num-constants.s"
#.include "words/dicthelp.s"

.include "words/cr.s"
.include "words/bl.s"
.include "words/space.s"
.include "words/spaces.s"
.include "words/left-bracket.s"
.include "words/l-paren.s"
.include "words/decimal.s"
.include "words/hex.s"
.include "words/binary.s"

.include "words/pad.s"
.include "words/here.s"
.include "words/ramhere.s"
.include "words/align.s"
.include "words/allot.s"

.include "words/hold.s"
.include "words/sharp.s"
.include "words/sign.s"
.include "words/dot.s"
.include "words/d-dot-r.s"
.include "words/d-dot.s"
.include "words/u-dot.s"
.include "words/u-dot-r.s"
.include "words/ud-dot.s"
.include "words/ud-dot-r.s"

.include "words/dot-s.s"
.include "words/dot-k.s"

.include "words/refill.s"
.include "words/accept.s"
.include "words/prompt-error.s"
.include "words/prompt-input.s"
.include "words/prompt-ok.s"
.include "words/prompt-ready.s"

.include "words/catch.s"
.include "words/throw.s"
.include "words/source.s"
.include "words/q-stack.s"
.include "words/cscan.s"
.include "words/cskip.s"
.include "words/parse-name.s"
.include "words/parse.s"
.include "words/slash-string.s"

.include "words/2literal.s"
.include "words/literal.s"
.include "words/xliteral.s"
.include "words/compile.s"
.include "words/comma.s"
.include "words/ccomma.s"
.include "words/immediate-q.s"
.include "words/order.s"
.include "words/find-xt.s"

.include "words/xt2string.s"
.include "words/dictopt-newb.s"

.include "words/traverse-wordlist.s"
.include "words/show-wordlist.s"
.include "words/current.s"
.include "words/search-wordlist.s"

.include "words/mplus.s"
.include "words/ud-star.s"
.include "words/within.s"
.include "words/to-upper.s"
.include "words/digit-q.s"
.include "words/to-number.s"
.include "words/number.s"
.include "words/q-sign.s"
.include "words/set-base.s"

.include "words/map-stack.s"
.include "words/qdo.s"

.include "words/init-ram.s"
.include "words/ver.s"

.include "words/count.s"
.include "words/type.s"
.include "words/squote.s"
.include "words/dot-quote.s"
.include "words/scomma.s"
.include "words/sliteral.s"
.include "words/words.s"

.include "words/l-mark.s"
.include "words/l-resolve.s"
.include "words/g-mark.s"
.include "words/g-resolve.s"
.include "words/ahead.s"
.include "words/begin.s"
.include "words/then.s"
.include "words/until.s"
.include "words/while.s"
.include "words/if.s"
.include "words/else.s"
.include "words/again.s"
.include "words/repeat.s"
.include "words/lstack.s"
.include "words/leave.s"
.include "words/immediate.s"
.include "words/turnkey.s"

.include "words/tick.s"
.include "words/abort.s"

.include "words/abort-string.s"
.include "words/backslash.s"
.include "words/bracketchar.s"
.include "words/bracketcompile.s"
.include "words/brackettick.s"
.include "words/char.s"
.include "words/colon-noname.s"
.include "words/constant.s"
.include "words/create.s"
.include "words/defer.s"
.include "words/defer-fetch.s"
.include "words/defer-store.s"
.include "words/do-create.s"
.include "words/do.s"
.include "words/endloop.s"
.include "words/header.s"
.include "words/latest.s"
.include "words/loop.s"
.include "words/newest.s"
.include "words/plusloop.s"
.include "words/postpone.s"
.include "words/q-abort.s"
.include "words/recurse.s"
.include "words/reveal.s"
.include "words/right-bracket.s"
.include "words/colon.s"
.include "words/semicolon.s"
.include "words/semicoloni.s"
.include "words/variable.s"
.include "words/wlscope.s"
.include "words/to-body.s"
.include "words/greater-zero.s"
.include "words/to-in.s"
.include "words/udefer.s"
.include "words/wordlist.s"
.include "words/ramwordlist.s"
.include "words/flag.s"
.include "words/search.s"

# TW testing 

.include "words/show.s"
.include "words/value.s"
.include "words/pvalue.s"
.include "words/mop.s"
.include "words/traps.s"
.include "words/forget.s"
.include "words/memmode.s"
.include "words/find.s"

.include "words/output.s"
.include "words/dump.s"
.include "words/testing.s"

.if WANT_TRANSPILER == YES
.include "words/tpile.s"
.endif

.if WANT_DEBUGGER == YES
.include "words/debugger.s"
.include "words/debugger2.s"
.include "words/barbar.s"
.endif

.include "words/dicthelp.s"
.if WANT_SEE 
.include "words/see.s"
.endif

.if WANT_MATCH
.include "words/match.s"
.endif

.if WANT_CASE
.include "words/case.s"
.endif

.if WANT_FORNEXT
.include "words/for-next.s"
.endif

.if WANT_FLOAT
.include "words/float.s"
.endif 

.if WANT_TABLE
.include "words/table.s"
.endif

.if WANT_SYNONYM
.include "words/synonym.s"
.endif

#.include "words/does.s"
#.include "words/code.s"


.include "words/is.s"
.include "words/alto.s"
#.include "words/to.s"


.include "words/mlc.s"
.include "words/char-plus.s"
.include "words/2store.s"
.include "words/2fetch.s"

.include "words/dallot.s"
.include "words/vallot.s"

.include "words/dhere.s"
.include "words/vhere.s"

.include "words/dalign.s"
.include "words/valign.s"

.include "words/evaluate.s"

.include "words/chkdalign.s"
.include "words/vdump.s"
.include "words/qnop.s"

.include "words/empty.s"
.include "words/builds.s"

