# Example: The Akbulut-Kirby presentation  for n = 2.
# (page 142 in the thesis of Ximena Fernandez)
gap> F:=FreeGroup("x","y");;
gap> AssignGeneratorVariables(F);
#I  Assigned the global variables [ x, y ]
gap>  R:=[x^2*y^-3,x*y*x*y^-1*x^-1*y^-1];;
gap>  G:=F/R;
<fp group on the generators [ x, y ]>
gap>  P:=PosetFpGroup(G);
<finite poset of size 53>
gap> A:= [ [ [ 2, "r", 1, 3, 1 ], [ 1, "rg", 1, 3 ] ], [ [ 1, "rg", 1, 1 ], [ 0, "r", 1 ] ], [ [ 2, "r", 1, 3, -1 ], [ 1, "gb", 2, 1 ] ], 
  [ [ 1, "rb", 1, 4 ], [ 0, "r", 1 ] ], [ [ 2, "r", 1, 3, -1 ], [ 1, "rg", 1, 3 ] ], [ [ 1, "rg", 2, 2 ], [ 0, "g", 2 ] ], 
  [ [ 1, "rg", 1, 3 ], [ 0, "r", 1 ] ], [ [ 1, "rb", 1, 4 ], [ 0, "b" ] ], [ [ 1, "rg", 1, 2 ], [ 0, "r", 1 ] ], 
  [ [ 2, "r", 2, 4, -1 ], [ 1, "rg", 2, 4 ] ], [ [ 1, "rg", 2, 3 ], [ 0, "r", 2 ] ], [ [ 1, "rg", 2, 5 ], [ 0, "g", 1 ] ], 
  [ [ 1, "rb", 2, 6 ], [ 0, "b" ] ], [ [ 2, "r", 1, 2, -1 ], [ 1, "rb", 1, 3 ] ], [ [ 2, "r", 2, 2, -1 ], [ 1, "gb", 2, -1 ] ], 
  [ [ 2, "r", 1, 2, 1 ], [ 1, "gb", 1, 1 ] ], [ [ 2, "r", 1, 2, 1 ], [ 1, "rb", 1, 2 ] ], [ [ 2, "r", 2, 2, 1 ], [ 1, "rb", 2, 2 ] ], 
  [ [ 2, "r", 1, 1, 1 ], [ 1, "rb", 1, 1 ] ], [ [ 2, "r", 2, 6, 1 ], [ 1, "gb", 2, -1 ] ], [ [ 2, "r", 2, 5, -1 ], [ 1, "rg", 2, 5 ] ], 
  [ [ 1, "rg", 2, 2 ], [ 0, "r", 2 ] ], [ [ 2, "r", 1, 1, 1 ], [ 1, "rg", 1, 1 ] ], [ [ 1, "rg", 1, 5 ], [ 0, "r", 1 ] ], 
  [ [ 2, "r", 1, 2, -1 ], [ 1, "rg", 1, 2 ] ], [ [ 1, "rb", 2, 4 ], [ 0, "b" ] ], [ [ 2, "r", 1, 1, -1 ], [ 1, "gb", 1, -1 ] ], 
  [ [ 1, "rb", 2, 4 ], [ 0, "r", 2 ] ], [ [ 1, "gb", 2, -1 ], [ 0, "b" ] ], [ [ 2, "r", 2, 2, 1 ], [ 1, "rg", 2, 2 ] ], 
  [ [ 1, "rg", 1, 4 ], [ 0, "g", 2 ] ], [ [ 1, "rg", 2, 4 ], [ 0, "r", 2 ] ], [ [ 2, "r", 1, 5, -1 ], [ 1, "rb", 1, 1 ] ], 
  [ [ 1, "rg", 2, 5 ], [ 0, "r", 2 ] ], [ [ 2, "r", 1, 4, -1 ], [ 1, "gb", 2, 1 ] ], [ [ 1, "rb", 1, 2 ], [ 0, "r", 1 ] ], 
  [ [ 2, "r", 2, 3, -1 ], [ 1, "rb", 2, 4 ] ], [ [ 2, "r", 2, 1, 1 ], [ 1, "rb", 2, 1 ] ], [ [ 1, "rb", 1, 5 ], [ 0, "r", 1 ] ], 
  [ [ 1, "gb", 1, -1 ], [ 0, "b" ] ], [ [ 1, "rb", 2, 1 ], [ 0, "b" ] ], [ [ 2, "r", 2, 4, -1 ], [ 1, "rb", 2, 5 ] ], 
  [ [ 2, "r", 2, 3, 1 ], [ 1, "gb", 1, 1 ] ], [ [ 1, "rb", 2, 3 ], [ 0, "r", 2 ] ], [ [ 2, "r", 2, 1, -1 ], [ 1, "gb", 1, -1 ] ], 
  [ [ 1, "rg", 2, 1 ], [ 0, "r", 2 ] ], [ [ 2, "r", 2, 6, -1 ], [ 1, "rb", 2, 1 ] ], [ [ 2, "r", 1, 4, 1 ], [ 1, "gb", 2, -1 ] ], 
  [ [ 2, "r", 2, 4, 1 ], [ 1, "rb", 2, 4 ] ], [ [ 2, "r", 2, 5, 1 ], [ 1, "rb", 2, 5 ] ], [ [ 2, "r", 1, 5, 1 ], [ 1, "rb", 1, 5 ] ], 
  [ [ 2, "r", 2, 6, 1 ], [ 1, "rg", 2, 6 ] ] ]; # a spanning tree found using RandomSpanningForest
gap> SimplifiedFpGroup(FundamentalGroupByColoring(P,A));
<fp group on the generators [  ]>
gap> while true do
>	A:=RandomSpanningForest(P);
>	if GeneratorsOfGroup(SimplifiedFpGroup(FundamentalGroupByColoring(P,A)))=[] then
>		Print("OK");
>		break;
> 	fi;
> od;
OK

