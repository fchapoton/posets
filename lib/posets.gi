#############################################################################
##
#W  posets.gi             posets Package
##
##
##  
##  
##


PosetFamily:=NewFamily("PosetFamily",IsPoset and IsMutable and IsCopyable);;
PosetType:=NewType(PosetFamily,  IsPoset and IsAttributeStoringRep);;

PosetHomomorphismFamily:=NewFamily("PosetHomomorphismFamily",IsPosetHomomorphism and IsMutable and IsCopyable );;
PosetHomomorphismType:=NewType(PosetHomomorphismFamily,  IsPosetHomomorphism and IsAttributeStoringRep );;

################################################################################

PosetsIntFunc.NewPoset := function() return Objectify( PosetType, rec(names:=[], ordering:=(function(x,y) end) ) ); end ;;

################################################################################

# Basic methods

InstallMethod(ViewObj,"for Poset",
[IsPoset],
function(X)
	Print("<finite poset of size ", Size(X) ,">");
end);

InstallMethod(ViewObj,"for PosetHomomorphism",
[IsPosetHomomorphism],
function(X)
	Print("<order preserving map>");
end);

# Set of points (forgets order)
InstallMethod(Set,"for Poset",
[IsPoset],
function(X)
	return X!.names;
end);

# Ordering function
InstallMethod(Ordering,"for Poset",
[IsPoset],
function(X)
	return X!.ordering;
end);


# Size (number of points)
InstallMethod(Size,"for Poset",
[IsPoset],
function(X)
	return Size(Set(X));
end);


InstallMethod(\=,"for Poset and Poset",
[IsPoset,IsPoset],
function(X1,X2)
	return Set(X1)=Set(X2) and ForAll(Set(X1), x-> ForAll(Set(X1), y-> Ordering(X1)(x,y)=Ordering(X2)(x,y)));
end);

InstallMethod(\<,"for Poset and Poset",
[IsPoset,IsPoset],
function(X1,X2)
	return Set(X1)<Set(X2) or (Set(X1)=Set(X2) and OrderMatrix(X1)<OrderMatrix(X2));
end);

InstallMethod(\=,"for PosetHomomorphism and PosetHomomorphism",
[IsPosetHomomorphism,IsPosetHomomorphism],
function(f,g)
	return [SourceMap(f), TargetMap(f), List(Set(SourceMap(f)),UnderlyingMap(f)) ] =  [SourceMap(g), TargetMap(g), List(Set(SourceMap(g)),UnderlyingMap(g)) ];
end);

# the purpose of defining this is total order to consider Sets of poset homomorphisms
# this order is not meaningful (it is not the same as the partial order f<g := (forall x) fx<gx )
InstallMethod(\<,"for PosetHomomorphism and PosetHomomorphism",
[IsPosetHomomorphism,IsPosetHomomorphism],
function(f,g)
	return [SourceMap(f), TargetMap(f), List(Set(SourceMap(f)),UnderlyingMap(f)) ] <  [SourceMap(g), TargetMap(g), List(Set(SourceMap(g)),UnderlyingMap(g)) ];
end);

################################################################################
# Basic functions to build posets

InstallMethod(PosetByFunctionNC,
"for Set, Function",
[IsList,IsFunction],
function(X,f)
	return Objectify( PosetType, rec(names:=Set(X), ordering:=f) );
end);

InstallMethod(PosetByFunction,
"for Set, Function",
[IsList,IsFunction],
function(X,f)
	local namesX;
	namesX:=Set(X);
	if not ForAll(namesX, x->f(x,x)) then
		Error("The relation is not reflexive");
	fi;
	if not ForAll(namesX,x-> ForAll( namesX, y->  not (f(x,y) and f(y,x)) or x=y )) then
		Error("The relation is not antisymmetric");
	fi;
	if not ForAll(namesX,x-> ForAll( namesX, y-> ForAll(namesX,z -> (not (f(x,y) and f(y,z) ) or f(x,z) )))) then
		Error("The relation is not transitive");
	fi;
	return PosetByFunctionNC(namesX,f);
end);





InstallMethod(PosetByOrderMatrix,
"for List",
[IsList],
function(M)
	return PosetByOrderMatrix([],M);
end);

InstallMethod(PosetByOrderMatrix,
"for List, List",
[IsList,IsList],
function(names,M)
	local poset,n,sigma,ordering;

	n:=Length(M);
	
	sigma:=[1..n];

	if names=[] then
		names:=[1..n];
	fi;
	if Length(names)<>n then
		Error("names must have "+String(n)+" elements");
	fi;

	SortParallel(names,sigma);

	if not ForAll(M, v->Length(v)=n) then
		Error("M is not a square matrix");
	fi;

	M:=	M{sigma}{sigma};

	if ForAll(Concatenation(M), IsInt ) then
		M:=List(M,v->List(v,x -> x<>0));
	fi;

	if not ForAll(Concatenation(M), x->x in [true,false] ) then
		Error("Every element of M must be true or false");
	fi;


	ordering:=function(x,y) return M[PositionSorted(names,x)][PositionSorted(names,y)]; end;
	
	poset:=PosetByFunction(names,ordering);

	poset!.orderMatrix:=M;

	return poset;

end);

# turns a relation into a poset
InstallMethod(PosetByOrderRelation,
"for PartialOrderBinaryRelation",
[IsPartialOrderBinaryRelation],
function(R)
	# this should be done without calling PosetByOrderMatrix!
	local M,n,names,U,i,y;
	n:=Size(Source(R));
	names:=Set(Source(R));
	M:=List([1..n],x->List([1..n],x->false));
	for i in [1..n] do
		U:=Images(R,names[i]);
		for y in U do
			M[i][Position(names,y)]:=true;
		od;
	od;
	return PosetByOrderMatrix(names,M);
		
end);

InstallMethod(PosetByCoveringRelations,
"for List, List",
[IsList,IsList],
function(names,coveringRelations)
	local R;
	# (some checks here)
	R:=TransitiveClosureBinaryRelation(ReflexiveClosureBinaryRelation(BinaryRelationByElements(Domain(Set(names)), List(coveringRelations,Tuple))));
	if not IsAntisymmetricBinaryRelation(R) then
		return fail;
	fi;
	return PosetByOrderRelation(R);
end);


##################################################################################################

# Methods to construct poset homomorphisms

InstallMethod(PosetHomomorphismByFunctionNC,
"for Poset, Poset and function",
[IsPoset, IsPoset, IsFunction],
function(X,Y,f)
	return Objectify( PosetHomomorphismType, rec(source:=X, target:=Y, f:=f) );
end);

InstallMethod(PosetHomomorphismByFunction,
"for Poset, Poset and function",
[IsPoset, IsPoset, IsFunction],
function(X,Y,f)
	if ForAll(Set(X),
				  x1->ForAll(Set(X),
                             x2-> (not Ordering(X)(x1,x2)) or Ordering(Y)(f(x1),f(x2))
							)
				)
	then
		return PosetHomomorphismByFunctionNC(X,Y,f);
	else
		return fail;
	fi;
end);

InstallMethod(PosetHomomorphismByImages,
"for Poset, Poset and List",
[IsPoset, IsPoset, IsList],
function(X,Y,ims)
	local f;
	if not Length(ims)=Size(X) and ForAll(ims, y->y in Set(Y) ) then
		Error("invalid arguments");
	fi;
	f:=function(x)
		return ims[PositionSorted(Set(X),x)];
	end;
	return PosetHomomorphismByFunction(X,Y,f);
end);

InstallMethod(PosetHomomorphismByMapping,
"for Poset, Poset and List",
[IsPoset, IsPoset, IsMapping],
function(X,Y,f)
	local fn;
	if not Source(f)=Set(X) and IsSubset(Set(Y), Set(Range(f)) ) then
		Error("invalid arguments");
	fi;
	fn:=function(x)
		return Image(f,x);
	end;
	return PosetHomomorphismByFunction(X,Y,fn);
end);

InstallMethod(IsomorphismPosets,
"for Poset and Poset",
[IsPoset, IsPoset],
function(X,Y)
	local n,iter,f,sigma;
	if Size(X)<>Size(Y) then
		return fail;
	fi;
	n:=Size(X);
	iter := Iterator(SymmetricGroup(n));
	for sigma in iter do
		f := PosetHomomorphismByFunction(X,Y, x-> Set(Y)[PositionSorted(Set(X),x)^sigma] );
		if f<>fail and PosetHomomorphismByFunction(Y,X, y-> Set(X)[PositionSorted(Set(Y),y)^(sigma^-1)] ) <> fail then
			return f;
		fi;
	od;
	return fail;
end);

InstallOtherMethod(IdentityMap,
"for Poset",
[IsPoset],
function(X)
	return PosetHomomorphismByFunction(X,X, x->x);
end);


InstallMethod(CompositionPosetHomomorphisms,
"for PosetHomomorphism and PosetHomomorphism",
[IsPosetHomomorphism,IsPosetHomomorphism],
function(g,f)
	if SourceMap(g)<>TargetMap(f) then
		return fail;
	fi;
	return PosetHomomorphismByFunctionNC(SourceMap(f),TargetMap(g), x-> (g!.f)(f!.f(x)) );
end);

InstallMethod(\*,
"for PosetHomomorphism and PosetHomomorphism",
[IsPosetHomomorphism,IsPosetHomomorphism],
function(g,f)
	return CompositionPosetHomomorphisms(f,g);
end);


InstallMethod(\*,
"for IsList and PosetHomomorphism",
[IsList,IsPosetHomomorphism],
function(l,g)
	if ForAll(l, IsPosetHomomorphism) then
		return List(l, f->f*g);
	else
		TryNextMethod();
	fi;
end);

InstallMethod(\*,
"for PosetHomomorphism and IsList",
[IsPosetHomomorphism,IsList],
function(f,l)
	if ForAll(l, IsPosetHomomorphism) then
		return List(l, g->f*g);
	else
		TryNextMethod();
	fi;
end);


InstallMethod(\^,
"for PosetHomomorphism and Integer",
[IsPosetHomomorphism,IsInt],
function(f,n)
	if n=1 then
		return f;
	fi;
	if n=-1 then
		return Inverse(f); # inverses not implemented!!!!
	fi;
	if SourceMap(f)=TargetMap(f) then
		if n=0 then return IdentityMap(SourceMap(f));fi;
		if n>0 then return f*(f^(n-1));fi;
		if n<0 and f^-1<> fail then
			return f^-1 * (f^(n+1));
		fi;
	fi;
	return fail;
end);


##################################################################################################


## Turns a poset into an order relation on [1..n]
InstallMethod(RelationByPoset,
"for Poset",
[IsPoset],
function(X)
	local n;
	n:=Size(X);
	return PartialOrderByOrderingFunction( Domain([1..Size(X)]),
											function(i,j) return Ordering(X)(Set(X)[i],Set(X)[j]);end
	);
end);




####################
InstallMethod(OrderMatrix,
"for Poset",
[IsPoset],
function(X)
	local n,M,i,j;
	if not IsBound(X!.orderMatrix) then
		n:=Size(X);
		M:=List([1..n],x->List([1..n], ReturnFalse));
		for i in [1..n] do
			for j in [1..n] do
				M[i][j]:=Ordering(X)(Set(X)[i],Set(X)[j]);
			od;
		od;
		X!.orderMatrix:=M;
	fi;
	X!.ordering:=function(x,y) return X!.orderMatrix[PositionSorted(Set(X),x)][PositionSorted(Set(X),y)]; end;
	return X!.orderMatrix;
	
end);

InstallMethod(UpperCovers,
"for Poset",
[IsPoset],
function(X)
	local uppercovers,c;
	uppercovers:=List([1..Size(X)], x->[]);
	for c in CoveringRelations(X) do
		Add(uppercovers[PositionSorted(Set(X),c[2])],c[1]);
	od;
	return x -> uppercovers[PositionSorted(Set(X),x)];
end);


InstallMethod(UpperCovers,
"for Poset and element",
[IsPoset,IsObject],
function(X,x)
	return UpperCovers(X)(x);
end);

InstallMethod(LowerCovers,
"for Poset",
[IsPoset],
function(X)
	local lowercovers,c;
	lowercovers:=List([1..Size(X)], x->[]);
	for c in CoveringRelations(X) do
		Add(lowercovers[PositionSorted(Set(X),c[1])],c[2]);
	od;
	return x -> lowercovers[PositionSorted(Set(X),x)];
end);

InstallMethod(LowerCovers,
"for Poset and element",
[IsPoset,IsObject],
function(X,x)
	return LowerCovers(X)(x);
end);

InstallMethod(CoveringRelations,
"for Poset",
[IsPoset],
function(X)
	local hasse_diagram,n;
	# if we know a grading for X we have a faster method
	if HasGrading(X) and Grading(X)<>fail then
		return Concatenation( List(Set(X), x-> List(Filtered(Set(X), y-> (Grading(X)(x) = 1+Grading(X)(y) ) and Ordering(X)(x,y) ), y-> [x,y] )));
	fi;
	# otherwise we compute covering relations from the Hasse diagram
	hasse_diagram := HasseDiagramBinaryRelation(RelationByPoset(X));
	n:=Size(X);
	return Set(Concatenation( List( [1..n], i-> List( Images( hasse_diagram, i ), j-> [ Set(X)[i], Set(X)[j] ] ))));
end);

InstallMethod(MaximalElements,
"for Poset",
[IsPoset],
function(X)
	return Filtered(Set(X), x-> UpperCovers(X,x)=[] ); # this is efficient if we already computed the upper covers, not in general!
end);



InstallMethod(MinimalElements,
"for Poset",
[IsPoset],
function(X)
	return Filtered(Set(X), x-> LowerCovers(X,x)=[] ); # this is efficient if we already computed the lower covers, not in general!
end);

