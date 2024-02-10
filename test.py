from pyswip import Prolog
prolog = Prolog()
prolog.consult("kb.pl")
ans = bool(list(prolog.query("p_parent(boris, derek)")))
print(ans)
ans = bool(list(prolog.query("p_parent(christian, derek)")))
print(ans)
prolog.assertz("parent(boris, derek)")
prolog.assertz("parent(christian, derek)")

ans = list(prolog.query("parent(X, derek)"))
print(ans)
