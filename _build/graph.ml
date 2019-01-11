type id = string



type 'a out_arcs = (id * 'a) list

(* A graph is just a list of pairs: a node & its outgoing arcs. *)
type 'a graph = (id * 'a out_arcs) list

exception Graph_error of string

let empty_graph = []

let node_exists gr id = List.mem_assoc id gr

let out_arcs gr id =
  try List.assoc id gr
  with Not_found -> raise (Graph_error ("Node " ^ id ^ " does not exist in this graph."))

let find_arc gr id1 id2 =
  let out = out_arcs gr id1 in
  try Some (List.assoc id2 out)
  with Not_found -> None

let add_node gr id =
  if node_exists gr id then raise (Graph_error ("Node " ^ id ^ " already exists in the graph."))
  else (id, []) :: gr

let add_arc gr id1 id2 lbl =

  (* Existing out-arcs *)
  let outa = out_arcs gr id1 in

  (* Update out-arcs.
   * remove_assoc does not fail if id2 is not bound.  *)
  let outb = (id2, lbl) :: List.remove_assoc id2 outa in
  
  (* Replace out-arcs in the graph. *)
  let gr2 = List.remove_assoc id1 gr in
  (id1, outb) :: gr2

let v_iter gr f = List.iter (fun (id, out) -> f id out) gr

let v_fold gr f acu = List.fold_left (fun acu (id, out) -> f acu id out) acu gr

let map (gr:'a graph) f =
  (List.map
     (fun (id_1,arc_out) -> (id_1, (List.map (fun (id_2, a) -> (id_2,f a)) arc_out )))
     gr:'b graph)


(* getGraph utlisée pour récupérer la liste qui constitue le graphe *)
let getGraph (gr: 'a graph) =
  match gr with
  |[] -> []
  |(id, out)::reste -> ((id, out)::reste)

(*utilisée pour construire un type graphe à partir d'une liste *)
let buildGraph l =
  match l with
  |[] -> []
  |(id, out)::reste -> ((id, out)::reste)

(*utilisée pour récupérer la liste d'un objet out_arcs *)
let getLOut outArcs =
  match outArcs with
  |[] -> []
  |(id, lab)::reste -> ((id, lab)::reste)

(*retourne arcs entrant dans id sous la forme (id*'a) *)
let in_arcs (gr: 'a graph) id =
  let rec parcoursOutArcs out acu =
    match out with
    |[] -> acu
    |(idX, label)::reste ->
      if id = idX
      then parcoursOutArcs reste (acu@[label])
      else parcoursOutArcs reste acu
  in
  let rec in_arcsAcu (gr: 'a graph) acu =
    match gr with
    |[] -> acu
    |(noeud, out)::reste ->
      if noeud = id
      then in_arcsAcu reste acu
      else in_arcsAcu reste
		      (acu@(List.map (fun label -> (noeud, label)) (parcoursOutArcs out [])))
  in
  in_arcsAcu gr []



	     
	     
	     
	     
	     

	     

	     