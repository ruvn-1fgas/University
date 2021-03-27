unit CommList;

interface
var k : integer;
type
    TValue = int64; 
    PValue = ^TValue;
    TNode = record
		value : TValue;
		next : ^TNode;
    end;
    PNode = ^TNode;
    TLinkedList = record
		first : ^TNode;
    end;
procedure list_create(var list : TLinkedList);

procedure list_delete(var list : TLinkedList);

function list_empty(list : TLinkedList) : Boolean;

procedure list_push(var list : TLinkedList; value : TValue);

procedure list_print(list : TLinkedList);

procedure list_help;

procedure list_pop(var list : TLinkedList);

procedure list_stacktop(var list : TLinkedList);

implementation 

procedure list_create(var list : TLinkedList);
begin
    list.first := nil;
end;

procedure list_delete(var list : TLinkedList);
var
    node : ^TNode;
begin
    while (list.first <> nil) do
    begin
		node := list.first^.next;
		dispose(list.first);
		list.first := node;
    end;
end;

function list_empty(list : TLinkedList) : Boolean;
type
	TPtr = ^TNode;
var
	head : ^TPtr;
	k: integer;
begin
	k:=0;
    head := @list.first;
	while head^ <> nil do
	begin
		head := @(head^)^.next;
		inc(k);
	end;
		    if (list.first = nil) or (k = 0) then
		writeln('Стек пуст')
    else
		if ((k mod 10 >= 5) and (k mod 10 <= 9) or (k mod 10 = 0)) or ((k mod 100 >= 11) and (k mod 100 <=19)) then
		writeln('В стеке ',k,' элементов') else
		if k mod 10 = 1 then
		writeln('В стеке ',k,' элемент')
		else
		if (k mod 10 >= 2) and (k mod 10 <= 4) then
		writeln('В стеке ',k,' элемента');
    list_empty := list.first <> nil;
end;

procedure list_push(var list : TLinkedList; value : TValue);
type
	TPtr = ^TNode;
var
    node : ^TNode;
	head : ^TPtr;
begin
    new(node);
    node^.value := value;
    node^.next := nil;	
	head := @list.first;
	while head^ <> nil do
	begin
		head := @(head^)^.next;
	end;
	head^ := node;
end;


procedure list_pop(var list : TLinkedList);
type
	TPtr = ^TNode;
var
	i:integer;
	head : ^TPtr;
begin
	k := 0;
	i := 0;
	head := @list.first;
	while head^ <> nil do
	begin
		head := @(head^)^.next;
		inc(k);
	end;

	head := @list.first;
	for i := 1 to k - 1 do
	begin
	head := @(head^)^.next;
	end;
	if (head^ = nil) then
		writeln('Стек уже пуст')
	else
	begin
		list_stacktop(list);
		head^ := nil;
	end;

end;

procedure list_print(list : TLinkedList);
var
    node : ^TNode;
begin
	node := list.first;
	while (node <> nil) do
	begin
		write(node^.value, ' ');
		node := node^.next;
	end;
	writeln;
end;

procedure list_stacktop(var list : TLinkedList);
type
	TPtr = ^TNode;
var
    node, node2: ^TNode;
	head : ^TPtr;
	k,i: integer;
begin
	k:=0;
	i:=0;
	head := @list.first;
	while head^ <> nil do
	begin
		head := @(head^)^.next;
		inc(k);
	end;
	if k = 0 then writeln('Стек пуст') else begin
	node := list.first;
	for i:= 1 to k -1 do
	begin
	node2 := node^.next;
	node := node2;
	end;
	writeln(node^.value);
	end;
end;

procedure list_help;
begin
	writeln('help - Список команд');
	writeln('push <value> - Добавление элемента в стек');
	writeln('pop  - Удаление элемента, находящегося в вершине стека');
	writeln('stacktop - Просмотр элемента в вершине стека');
	writeln('empty - Определение пустоты стека');
	writeln('print - Вывод всех элементов стека');
	writeln('clear - Очистка стека');
	writeln('exit - Выход из программы');
end;
end.
