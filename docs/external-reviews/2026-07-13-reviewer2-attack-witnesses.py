"""
Executable illustrations of several Reviewer #2 counterexamples.
This script mirrors only the small transition/quorum definitions needed
for the witnesses; it is not a Lean verification.
"""

from dataclasses import dataclass
from enum import Enum, auto


class State(Enum):
    IDLE = auto()
    PENDING = auto()
    HOLD = auto()
    SPENT = auto()
    CONFIRMED = auto()


@dataclass(frozen=True)
class Input:
    issue: bool = False
    confirm: bool = False
    novel: bool = False
    exceedance: bool = False
    layer0: bool = False


def estep(state: State, inp: Input, h: int = 0):
    if state is State.IDLE:
        return (State.PENDING, 0) if inp.issue else (State.IDLE, None)
    if state is State.PENDING:
        if inp.confirm:
            return (State.CONFIRMED, None)
        if h + 1 < 72:
            return (State.PENDING, h + 1)
        return (State.HOLD if inp.exceedance else State.SPENT, None)
    if state is State.HOLD:
        if inp.layer0:
            return (State.IDLE, None)
        if inp.novel and inp.issue:
            return (State.PENDING, 0)
        return (State.HOLD if inp.exceedance else State.SPENT, None)
    if state is State.SPENT:
        if inp.novel and inp.issue:
            return (State.PENDING, 0)
        return (State.HOLD if inp.exceedance else State.SPENT, None)
    return (State.CONFIRMED, None)


def layer0_restart_witness():
    s1, _ = estep(
        State.HOLD,
        Input(layer0=True, novel=False, issue=False, exceedance=True),
    )
    s2, h2 = estep(
        s1,
        Input(layer0=False, novel=False, issue=True, exceedance=True),
    )
    return s1, s2, h2


def exceedance_certified(f: int, threshold: int, reports):
    # report = (reading, is_honest)
    return sum(reading >= threshold for reading, _ in reports) >= f + 1


def weak_quorum_witness():
    f = 1
    threshold = 50
    reports = [
        (100, False),  # corrupt high
        (100, True),   # one honest high/outlier
        (0, True),
        (0, True),
    ]
    honest_above = sum(r >= threshold for r, honest in reports if honest)
    honest_below = sum(r < threshold for r, honest in reports if honest)
    return {
        "certified": exceedance_certified(f, threshold, reports),
        "honest_above": honest_above,
        "honest_below": honest_below,
        "reports": reports,
    }


if __name__ == "__main__":
    s1, s2, h2 = layer0_restart_witness()
    print("Layer-0 stale restart:")
    print("  hold ->", s1.name, "->", s2.name, h2)
    print("  novelty was false in both inputs")

    print("\nWeak f+1 exceedance quorum:")
    result = weak_quorum_witness()
    for key, value in result.items():
        print(f"  {key}: {value}")

    print("\nCertificate bypass is a type/interface witness:")
    print("  requiredTierC(route d outside envelope) = Tier 3")
    print("  pioAuthorizes(issued 0, M1) = true under the legacy Mech table")
    print("  therefore the stricter action API is not enforced by PIO/hold")
