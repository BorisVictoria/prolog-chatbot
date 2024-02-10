from pyswip import Prolog

prolog = Prolog()


def statement(entry):
    entry = entry[:-1]
    entry = entry.lower()
    entry = entry.split()

    possible = True

    # as long as one assertion is a contingency, entailment is false because at least one thing was learned
    entailment = True

    assertions = list()
    if "and" in entry:
        if "siblings" in entry:
            entailment = bool(list(prolog.query(f"sibling({entry[0]}, {entry[2]})")))
            possible = bool(list(prolog.query(f"p_sibling({entry[0]}, {entry[2]})")))

            assertions.append(f"sibling({entry[0]}, {entry[2]})")

        elif "children" in entry:
            num_children = len(entry) - 5

            for i in range(0, num_children - 2):
                local_entailment = bool(list(prolog.query(f"parent({entry[len(entry) - 1]}, {entry[i][:-1]})")))

                if not local_entailment:
                    entailment = False

                if not bool(list(prolog.query(f"p_parent({entry[len(entry) - 1]}, {entry[i][:-1]})"))):
                    possible = False

                if not local_entailment:
                    assertions.append(f"parent({entry[len(entry) - 1]}, {entry[i][:-1]})")

            for i in range(num_children - 2, num_children + 1, 2):
                local_entailment = bool(list(prolog.query(f"parent({entry[len(entry) - 1]}, {entry[i]})")))

                if not local_entailment:
                    entailment = False

                if not bool(list(prolog.query(f"p_parent({entry[len(entry) - 1]}, {entry[i]})"))):
                    possible = False
                    print()

                if not local_entailment:
                    assertions.append(f"parent({entry[len(entry) - 1]}, {entry[i]})")

        elif "parents" in entry:
            local_entailment = bool(list(prolog.query(f"parent({entry[0]}, {entry[7]})")))

            if not local_entailment:
                entailment = False

            if not bool(list(prolog.query(f"p_parent({entry[0]}, {entry[7]})"))):
                possible = False

            if not local_entailment:
                assertions.append(f"parent({entry[0]}, {entry[7]})")

            # second
            local_entailment = bool(list(prolog.query(f"parent({entry[2]}, {entry[7]})")))

            if not local_entailment:
                entailment = False

            prolog.assertz(f"parent({entry[0]}, {entry[7]})")

            if not bool(list(prolog.query(f"p_parent({entry[2]}, {entry[7]})"))):
                possible = False

            prolog.retract(f"parent({entry[0]}, {entry[7]})")

            if not local_entailment:
                assertions.append(f"parent({entry[2]}, {entry[7]})")

    else:
        entailment = bool(list(prolog.query(f"{entry[3]}({entry[0]}, {entry[5]})")))
        possible = bool(list(prolog.query(f"p_{entry[3]}({entry[0]}, {entry[5]})")))

        if not entailment:
            assertions.append(f"{entry[3]}({entry[0]}, {entry[5]})")

    if entailment:
        print("\n[ChatBot]:\tI already knew that.")

    elif not possible:
        print("\n[ChatBot]:\tThat's impossible.")
    else:
        for assertion in assertions:
            prolog.assertz(assertion)
        print("\n[ChatBot]:\tUnderstood! I learned something new.")


def question(entry):
    entry = entry[:-1]
    entry = entry.lower()

    entry = entry.split()
    query = ""

    # Is ____ the _____ of _____
    if entry[0] == "is":
        query = f"{entry[3]}({entry[1]}, {entry[5]})"
        yes_or_no(prolog.query(query))

    # Are ____ and ____
    elif entry[0] == "are":
        if "children" in entry:
            query = (f"parent({entry[7]}, {entry[1][:-1]}), "
                     f"parent({entry[7]}, {entry[2]}), "
                     f"parent({entry[7]}, {entry[4]})")
        elif "parents" in entry:
            query = f"parent({entry[1]}, {entry[7]}), parent({entry[3]}, {entry[7]})"
        elif "relatives" in entry:
            query = f"relative({entry[1]}, {entry[3]})"
        elif "siblings" in entry:
            query = f"sibling({entry[1]}, {entry[3]})"
        yes_or_no(prolog.query(query))

    # Who is _____
    elif entry[1] == "is":
        query = f"{entry[3]}(X, {entry[5]})"
        names(prolog.query(query))

    # Who are ____
    elif entry[1] == "are":
        if entry[3] == "children":
            query = f"child(X, {entry[5]})"
        else:
            query = f"{entry[3][:-1]}(X, {entry[5]})"
        names(prolog.query(query))


def yes_or_no(result):
    if bool(list(result)):
        print("\n[ChatBot]:\tYes.")
    else:
        print("\n[ChatBot]:\tNo.")


def names(raw_result):
    result = list(raw_result)
    if len(result) == 0:
        print("\n[ChatBot]:\tNone.")
    if len(result) == 1:
        print("\n[ChatBot]:\t" + result[0].get("X").capitalize() + ".")
    if len(result) == 2:
        print(f"\n[ChatBot]:\t{result[0].get("X").capitalize()} and {result[1].get("X").capitalize()}.")
    if len(result) >= 3:
        to_print = "\n[ChatBot]:\t"
        for i in range(0, len(result)):
            if i != len(result) - 1:
                to_print += result[i].get("X").capitalize() + ", "
            else:
                to_print += "and " + result[i].get("X").capitalize() + "."
        print(to_print)


def main():
    prolog.consult("kb.pl")

    print("\n[ChatBot]:\tWelcome! I'm here to untangle your family tree.")

    entry = ""
    while not entry == "Goodbye.":
        entry = input("\n[You]:\t\t")

        # noinspection PyBroadException
        try:
            if entry[-1][-1] == "." and entry != "Goodbye.":
                statement(entry)

            elif entry[-1][-1] == "?":
                question(entry)
            else:
                print("\n[ChatBot]:\tStatement must end with either a '.' or '?'")
        except:
            print("\n[ChatBot]:\tInvalid input. Please follow the required sentence patterns.")


if __name__ == "__main__":
    main()
