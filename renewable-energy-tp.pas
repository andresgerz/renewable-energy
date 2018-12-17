program renewable_energy_tp;
uses
        crt;
const
        nro_centrales=100;
type
tRcentralener=record  {record de centrales}
        nombre:string;
        prov:string;
        lat:real;
        long:real;
        potencia_gen:real;
        tipo_de_central:string;
end;
tRdemanda=record    {record de demandas}
        nombre_zona:string;
        provd:string;
        ciudad:string;
        latd:real;
        longd:real;
        demanda:real;
end;
tcentralener = array[1..nro_centrales] of tRcentralener;      {Vector centrales de energ¡a}
tdemanda = array[1..nro_centrales] of tRdemanda;              {vector demandas}
T_conjunto1 = set of char;                                    {conjunto para la validacaion de reales}
{-------------------------------------------------------------------------------------}
function celdavaciacentrales(centrales:tcentralener):integer;  {funcion que se fija cual es la celda vacia de las centrales}
var
        j:integer;
begin
        j:=0;
        repeat
                inc(j);
        until (centrales[j].nombre=' ') or (j=nro_centrales);
        if (j=nro_centrales) and (centrales[j].nombre<>' ') then
                celdavaciacentrales:=0
        else
                celdavaciacentrales:=j;
end;
function celdavaciademandas(demandas:tdemanda):integer; {funcion que se fija cual es la celda vacia de demandas}
var
        j:integer;
begin
        j:=0;
        repeat
                inc(j);
        until (demandas[j].nombre_zona=' ') or (j=nro_centrales);
        if (j=nro_centrales) and (demandas[j].nombre_zona<>' ') then
                celdavaciademandas:=0
        else
                celdavaciademandas:=j;
end;
function validar:real; {vafuncion que permite validar los reales}
var
        caract:T_conjunto1;
        c:char;
        cad:string;
        r:real;
        cod:longint;
begin
        caract:=['.',',','-','0'..'9'];
        cad:='';
        repeat
                c:=readkey;
                if (c in caract) then
                begin
                        write(c);
                        if ('-' in caract) then
                                caract:=caract-['-'];
                        if (c=',') or (c='.') then
                        begin
                                caract:=caract-['.',','];
                                c:='.';
                        end;
                        cad:=cad+c;
                end;
        until (length(cad)=25) or (c=#13);
        val(cad,r,cod);
        validar:=r;
        writeln;
end;
function mostrar_menor(demandas:tdemanda):string;{funcio que permite mostrar la menor demanda}
var
        i,j:integer;
        min:real;
        zonamin:string;
begin
        j:=celdavaciademandas(demandas);
        min:=100000000;
        for i:=1 to j-1 do
        begin
                if demandas[i].demanda<min then
                begin
                        min:=demandas[i].demanda;
                        zonamin:=demandas[i].nombre_zona;
                end;
        end;
        mostrar_menor:=zonamin;
end;



function produccion_total(centrales:tcentralener):real;{funcion que permite mostrar la produccion total en un cudrante}
var
        i:integer;
        total:real;
begin
        total:=0;
        for i:=1 to nro_centrales do
        begin
                if (centrales[i].lat>=-31) and (centrales[i].lat<=-20) and (centrales[i].long>=-70) and (centrales[i].long<=-60) then
                        total:=total+centrales[i].potencia_gen;
        end;
        produccion_total:=total;
end;
function demandatotal(demandas:tdemanda):real; {funcion que permite calcular la demanda por encima de una latitud}
var
        i:integer;
        total:real;
begin
        total:=0;
        for i:=1 to nro_centrales do
        begin
                if (demandas[i].latd>=-35.705) then
                         total:=total+demandas[i].demanda;
        end;
        demandatotal:=total;
end;


procedure interpalabra(var a,b:string); {burbujeo de palabras}
var
       aux:string;
begin
        aux:=a;
        a:=b;
        b:=aux;
end;
procedure intercambio(var a,b:real); {burbujeo de los reales}
var
       aux:real;
begin
        aux:=a;
        a:=b;
        b:=aux;
end;
procedure listarsolar(centrales:tcentralener);{lista las centrales solares}
var
        i,j,a,b,c:integer;
begin
        j:=0;
        c:=celdavaciacentrales(centrales);
        for i:=1 to c do
        begin
                if centrales[i].tipo_de_central='solar' then
                begin
                        j:=j+1;
                        centrales[j].prov:=centrales[i].prov;
                        centrales[j].tipo_de_central:=centrales[i].tipo_de_central;
                        centrales[j].potencia_gen:=centrales[i].potencia_gen;
                        centrales[j].nombre:=centrales[i].nombre;
                        centrales[j].lat:=centrales[i].lat;
                        centrales[j].long:=centrales[i].long;
                end;
        end;
        for a:=1 to j-1 do
        begin
                for b:=1 to j-a do
                begin
                        if centrales[b].prov>centrales[b+1].prov then
                        begin
                                interpalabra(centrales[b].prov,centrales[b+1].prov);
                                intercambio(centrales[b].potencia_gen,centrales[b+1].potencia_gen);
                        end;
                end;
        end;
        for b:=1 to j do
                writeln(b,') ',centrales[b].prov,' --> ',centrales[b].potencia_gen:0:2,' mW');
        readkey;
        clrscr;
end;
procedure listareolicas(centrales:tcentralener); {lista las centrales eolicas}
var
        i,j,a,b,c:integer;
begin
        j:=0;
        c:=celdavaciacentrales(centrales);
        for i:=1 to c do
        begin
                if centrales[i].tipo_de_central='eolica' then
                begin
                        j:=j+1;
                        centrales[j].potencia_gen:=centrales[i].potencia_gen;
                        centrales[j].nombre:=centrales[i].nombre;
                        centrales[j].prov:=centrales[i].prov;
                        centrales[j].lat:=centrales[i].lat;
                        centrales[j].long:=centrales[j].long;
                end;
        end;
        for a:=1 to j-1 do
        begin
                for b:=1 to j-a do
                begin
                        if centrales[b].potencia_gen>centrales[b+1].potencia_gen then
                        begin
                                intercambio(centrales[b].potencia_gen,centrales[b+1].potencia_gen);
                                interpalabra(centrales[b].nombre,centrales[b+1].nombre);
                        end;
                end;
        end;
        case j of
                0:begin
                        writeln('No hay centrales eolicas');
                        readkey;
                        clrscr;
                  end;
                1:begin
                        writeln('1) ',centrales[j].potencia_gen:0:2,' mW ',centrales[j].nombre);
                        readkey;
                        clrscr;
                  end;
                2:begin
                        writeln('1) ',centrales[j-1].potencia_gen:0:2,' mW ',centrales[j-1].nombre);
                        writeln('2) ',centrales[j].potencia_gen:0:2,' mW ',centrales[j].nombre);
                        readkey;
                        clrscr;
                  end;
                3..nro_centrales:begin
                                        writeln('1) ',centrales[j-2].potencia_gen:0:2,' mW ',centrales[j-2].nombre);
                                        writeln('2) ',centrales[j-1].potencia_gen:0:2,' mW ',centrales[j-1].nombre);
                                        writeln('3) ',centrales[j].potencia_gen:0:2,' mW ',centrales[j].nombre);
                                        readkey;
                                        clrscr;
                                 end;
        end;
end;
procedure listarmax(centrales:tcentralener);{lista las centrales que generan mas que la cota}
var
i,j,a,b,c,h:integer;
begin
        j:=0;
        c:=celdavaciacentrales(centrales);
        for i:=1 to c do
        begin
                if centrales[i].potencia_gen>15 then
                begin
                        j:=j+1;
                        centrales[j].potencia_gen:=centrales[i].potencia_gen;
                        centrales[j].nombre:=centrales[i].nombre;
                        centrales[j].prov:=centrales[i].prov;
                        centrales[j].lat:=centrales[i].lat;
                        centrales[j].long:=centrales[i].long;
                        centrales[j].tipo_de_central:=centrales[j].tipo_de_central;
                end;
        end;
        for a:=1 to j-1 do
        begin
                for b:=1 to j-a do
                begin
                        if centrales[b].nombre>centrales[b+1].nombre then
                        begin
                                interpalabra(centrales[b].nombre,centrales[b+1].nombre);
                                intercambio(centrales[b].potencia_gen,centrales[b+1].potencia_gen);
                        end;
                end;
        end;
        for b:=1 to j do
                writeln(b,') ',centrales[b].nombre,' mW --> ',centrales[b].potencia_gen:0:2);
        readkey;
        clrscr;
end;
procedure mostrarcentrales(centrales:tcentralener);{muestra las centrales que se van a usar en modificar y borrar}
var
        j,i:integer;
begin
        j:=celdavaciacentrales(centrales);
        for i:=1 to j-1 do
                writeln(i,') ',centrales[i].nombre);
        readkey;
end;
procedure mostrardemanda(demanda:tdemanda);{muestra las demandas que se van a la hora de borrar y modificar}
var
        i,j:integer;
begin
        j:=celdavaciademandas(demanda);
        for i:=1 to j-1 do
                writeln(i,') ',demanda[i].nombre_zona);
        readkey;
end;
function mostrarmaxcen(central:tcentralener):integer;{cuenta cotas para que una persona no pueda elegir valores que no esten en la lista}
var
    i,j:integer;
begin
        j:=celdavaciacentrales(central);
        for i:=1 to j-1 do
                mostrarmaxcen:=i;
end;
function mostrarmaxdem(demanda:tdemanda):integer;{idem al anterior pero para demandas}
var
     i,j:integer;
begin
        j:=celdavaciademandas(demanda);
        for i:=1 to j-1 do
                mostrarmaxdem:=i;
end;
procedure modificarcentrales(var centrales:tcentralener);{procedimiento que permite modificar las centrales}
var
        i,j,k,error,error1,error2:integer;
        a,b,c:string[25];
begin
        clrscr;
        writeln('Ingrese  el numero de la central que desea modificar: ');
        repeat
            mostrarcentrales(centrales);
            readln(a);
            val(a,i,error);
            while  (error<>0) do
            begin
                    writeln('Vuelva a ingresar el numero');
                    readln(a);
                    val(a,i,error);
            end;
        until (i>=1) and (i<=mostrarmaxcen(centrales));
        repeat
                repeat
                        clrscr;
                        writeln('1) Nombre de la central: ');
                        writeln('2) Provincia: ');
                        writeln('3) Latitud: ');
                        writeln('4) Longitud: ');
                        writeln('5) Potencia generada: ');
                        writeln('6) Tipo de Central: ');
                        writeln('7) Salir de la modificacion');
                        readln(b);
                        val(b,j,error1);
                        while (error1<>0) do
                        begin
                                writeln('Vuelva a ingresar el numero');
                                readln(b);
                                val(b,j,error1);
                        end;
                until (j>=1) or (j<=7);
                clrscr;
                case j of
                         1:begin
                                writeln('Nombre de la Central');
                                readln(centrales[i].nombre);
                           end;
                         2:begin
                                writeln('Provincia');
                                readln(centrales[i].prov);
                           end;
                         3:begin
                                repeat
                                        writeln('Latitud entre(-90 y 90)');
                                        centrales[i].lat:=validar;
                                until(centrales[i].lat>=-90) and (centrales[i].lat<=90);
                           end;
                         4:begin
                                repeat
                                        writeln('Longitud entre(-90 y 90)');
                                        centrales[i].long:=validar;
                                until (centrales[i].long>=-90) and (centrales[i].long<=90);
                           end;
                         5:begin
                                repeat
                                        writeln('Potencia Generada entre(0 y 25000)');
                                        centrales[i].potencia_gen:=validar;
                                until (centrales[i].potencia_gen>0) and (centrales[i].potencia_gen<=25000);
                           end;
                         6:begin
                                repeat
                                        writeln('Tipos de Centrales');
                                        writeln('1) Eolica');
                                        writeln('2) Solar');
                                        writeln('3) Otras');
                                        readln(c);
                                        val(c,k,error2);
                                until (k>=1) and (k<=3);
                                while error2<>0 do
                                begin
                                        writeln('Ingrese de nuevo el numero');
                                        readln(c);
                                        val(c,k,error2);
                                end;
                                case k of
                                        1: centrales[i].tipo_de_central:='eolica';
                                        2: centrales[i].tipo_de_central:='solar';
                                        3: centrales[i].tipo_de_central:='otras';
                                end;
                           end;
                end;
        until (j=7);
        clrscr;
end;


procedure modificardemandas(var demanda:tdemanda);{idem al anterior pero para modificar demandas}
var
        i,error,error1:integer;
        j:integer;
        a,b:string[25];
begin
        clrscr;
        writeln('Ingrese el numero del lugar que desea modificar');
        repeat
            mostrardemanda(demanda);
            readln(a);
            val(a,i,error);
            while (error<>0) do
            begin
                    writeln('Vuelva a ingresar el valor');
                    readln(a);
                    val(a,i,error);
            end;
        until (i>=1) and (i<=mostrarmaxdem(demanda));
        repeat
                repeat
                        writeln('1) Nombre de la zona: ');
                        writeln('2) Provincia: ');
                        writeln('3) Ciudad: ');
                        writeln('4) Latitud: ');
                        writeln('5) Longitud: ');
                        writeln('6) Demanda: ');
                        writeln('7) No desea modificar mas');
                        readln(b);
                        val(b,j,error1);
                        while (error1<>0) do
                        begin
                                writeln('Vuelva a ingresar un numero');
                                readln(b);
                                val(b,j,error1);
                        end;
                        clrscr;
                until (j>=1) and (j<=7);
                case j of
                         1:begin
                                writeln('Nombre de la Zona');
                                readln(demanda[i].nombre_zona);
                           end;
                         2:begin
                                writeln('Provincia');
                                readln(demanda[i].provd);
                           end;
                         3:begin
                                writeln('Ciudad');
                                readln(demanda[i].ciudad);
                           end;
                         4:begin
                                repeat
                                        writeln('Latitud ente(-90 y 90)');
                                        demanda[i].latd:=validar;
                                until (demanda[i].latd>=-90) and (demanda[i].latd<=90);
                           end;
                         5:begin
                                repeat
                                        writeln('Longitud entre(-90 y 90)');
                                        demanda[i].longd:=validar;
                                until (demanda[i].longd>=-90) and (demanda[i].longd<=90);
                           end;
                         6:begin
                                repeat
                                        writeln('Demanda entre(0 y 25000)');
                                        demanda[i].demanda:=validar;
                                until (demanda[i].demanda>0) and (demanda[i].demanda<=25000);
                           end;
                end;
        until j=7;
        clrscr;
end;


procedure borrarcentrales(var centrales:tcentralener);{permite borrar centrales}
var
        i,a,error:integer;
        j:string[25];
begin
        clrscr;
        a:=celdavaciacentrales(centrales);
        if a=1 then
                begin
                        writeln('No hay centrales, presione enter para salir');
                        readkey;
                        clrscr;
                end
        else
                begin
                        writeln('Ingrese la posicion de la central que desea borrar');
                        repeat
                                mostrarcentrales(centrales);
                                readln(j);
                                val(j,i,error);
                                while (error<> 0) do
                                begin
                                        writeln('Vuelva a ingresar el numero');
                                        readln(j);
                                        val(j,i,error);
                                end;
                        until (i>=1) and (i<=mostrarmaxcen(centrales));
                        for i:=i to a do
                        centrales[i]:=centrales[i+1];
                        clrscr;
                end;
end;


procedure borrardemandas(var demandas:tdemanda);{permite borrar zonas de demandas}
var
        i,a,error:integer;
        j:string[25];
begin
        clrscr;
        a:=celdavaciademandas(demandas);
        if a=1 then
                begin
                        writeln('No hay zonas para borrar, presione enter para salir');
                        readkey;
                        clrscr;
                end
        else
                begin
                        writeln('Ingrese la posicion de la zona que desea borrar');
                        repeat
                                mostrardemanda(demandas);
                                readln(j);
                                val(j,i,error);
                                while(error<>0) do
                                begin
                                        writeln('Vuelva a ingresar el numero');
                                        readln(j);
                                        val(j,i,error);
                                end;
                        until (i>=1) and (i<=mostrarmaxdem(demandas));
                        for i:=i to a do
                                demandas[i]:=demandas[i+1];
                        clrscr;
                end;
end;

procedure iniciarcentrales(var centrales:tcentralener);{inicializa los vectores en 0 o vacio}
var
        pos: integer;
begin
        for pos:=1 to nro_centrales do
        begin
                centrales[pos].nombre:=' ';
                centrales[pos].prov:=' ';
                centrales[pos].lat:=0;
                centrales[pos].long:=0;
                centrales[pos].potencia_gen:=0;
                centrales[pos].tipo_de_central:=' ';
        end;
end;

procedure iniciardemandas(var demandas:tdemanda);{Idem anterior pero para las demandas}
var
        pos: integer;
begin
        for pos:=1 to nro_centrales do
        begin
                demandas[pos].nombre_zona:=' ';
                demandas[pos].provd:=' ';
                demandas[pos].ciudad:=' ';
                demandas[pos].latd:=0;
                demandas[pos].longd:=0;
                demandas[pos].demanda:=0;
        end;
end;



procedure cargarcentrales(var central:tcentralener);{carga centrales}
var
        j,a,error:integer;
        b:string[25];

begin
        j:=celdavaciacentrales(central);
        writeln('Nombre de la central; ');
        readln(central[j].nombre);
        writeln('Provincia: ');
        readln(central[j].prov);
        repeat
                writeln('Latitud entre(-90 y 90): ');
                central[j].lat:=validar;
        until(central[j].lat>=-90) and (central[j].lat<=90);
        repeat
                writeln('Longitud entre(-90 y 90): ');
                central[j].long:=validar;
        until(central[j].long>=-90) and (central[j].long<=90);
        repeat
                writeln('Potencia Generada entre (0 y 25000): ');
	        central[j].potencia_gen:=validar;
        until(central[j].potencia_gen>0) and (central[j].potencia_gen<=25000);
	writeln('Tipo de Central: ');
        repeat
                writeln('1) Eolica');
                writeln('2) Solar');
                writeln('3) Otras');
                readln(b);
                val(b,a,error);
        until (a>=1) and (a<=3);
        while error<>0 do
        begin
                writeln('Ingrese de nuevo el numero');
                readln(b);
                val(b,a,error);
        end;
        case a of
                1: central[j].tipo_de_central:='eolica';
                2: central[j].tipo_de_central:='solar';
                3: central[j].tipo_de_central:='otras';
        end;
        clrscr;
end;

procedure cargardemandas(var demanda:tdemanda);{carga demandas}
var
        j: integer;
begin
        j:=celdavaciademandas(demanda);
        writeln('Nombre de la zona; ');
        readln(demanda[j].nombre_zona);
        writeln('Provincia: ');
        readln(demanda[j].provd);
        writeln('Ciudad: ');
        readln(demanda[j].ciudad);
        repeat
                writeln('Latitud entre(-90 y 90): ');
                demanda[j].latd:=validar;
        until (demanda[j].latd>=-90) and (demanda[j].latd<=90);
        repeat
                writeln('Longitud entre(-90 y 90): ');
                demanda[j].longd:=validar;
        until (demanda[j].longd>=-90) and (demanda[j].longd<=90);
        repeat
                writeln('Demanda entre(0 y 25000): ');
                demanda[j].demanda:=validar;
        until (demanda[j].demanda>0) and (demanda[j].demanda<=25000);
        clrscr;
end;
procedure precargarcentrales(var centralener:tcentralener);{hace la precarga de datos}
begin
     with centralener[1] do
        begin
                nombre:= 'Parque Eolico Arauco';
                prov:= 'la rioja';
                lat := -28.550027 ;
                long := -66.819562;
                potencia_gen:= 25.2;
                tipo_de_central:= 'eolica';
        end;
        with centralener[2] do
        begin
                nombre:= 'Parque Eolico Loma Blanca';
                prov:= 'chubut';
                lat := -43.273821 ;
                long := -65.326612;
                potencia_gen:= 50;
                tipo_de_central:= 'eolica';
        end;
        with centralener[3] do
        begin
                nombre:= 'Parque Solar Fotovoltaico Caniada Honda';
                prov:= 'san juan';
                lat := -32.103783 ;
                long := -68.845612;
                potencia_gen:= 15;
                tipo_de_central:= 'solar';
        end;
end;
procedure precargademanda(var demanda:tdemanda);{precarga de datos}
begin
        with demanda[1] do
        begin
                nombre_zona:= 'Metropolitana';
                provd:= 'Buenos Aires';
                ciudad:= 'CABA';
                latd := -34.603720 ;
                longd := -58.381656;
                demanda:= 8000;
        end;
        with demanda[2] do
        begin
                nombre_zona:= 'Gran Rosario';
                provd:= 'Santa Fe';
                ciudad:= 'Rosario';
                latd := -32.952284 ;
                longd := -60.632242;
                demanda:= 3000;
        end;
        with demanda[3] do
        begin
                nombre_zona:= 'NOA';
                provd:= 'Jujuy, Salta, Tucuman, Catamarca, La Rioja, Santiago del Estero';
                ciudad:= 'Varias';
                latd := -24.804483 ;
                longd := -65.415182;
                demanda:= 2200;
        end;
end;
procedure menu(var demandas:tdemanda; centrales:tcentralener); {menu}
var
        opcion,error:integer;
        a:string[25];
        prodtotal,demtotal:real;
        mosmenor:string;
begin
        clrscr;
        repeat
                repeat
                        writeln('                                              Menu');
                        writeln('1- Agregar Central.');
                        writeln('2- Agregar Zona de demanda.');
                        writeln('3- Borrar Central.');
                        writeln('4- Borrar Zona de demanda.');
                        writeln('5- Modificar Central.');
                        writeln('6- Modificar Zona de demanda.');
                        writeln('7- Listar las 3 Centrales eolicas que mas producen.');
                        writeln('8- Mostrar la Ciudad o Zona que menos consume en Argentina.');
                        writeln('9- Demanda total a partir de la latitud -35.705§.');
                        writeln('10- Produccion total de las centrales comprendidas en la zona dada por las siguientes coordenadas: (-31§;-60§),(-20§;-60§),(-31§;-70§),(-20§;-70§).');
                        writeln('11- Listar en forma ascendente aquellas centrales que producen mas de 15 mW.');
                        writeln('12- Listar todas las centrales solares en forma ascendente por nombre de provincia');
                        writeln('13- Salir del Programa');
                        readln(a);
                        val(a,opcion,error);
                        while(error<>0) do
                        begin
                                writeln('Ingrese de nuevo el numero');
                                readln(a);
                                val(a,opcion,error);
                        end;
                        clrscr;
                until (opcion>=1)and(opcion<=13);
                case opcion of
                 1:cargarcentrales(centrales);
                 2:cargardemandas(demandas);
                 3:borrarcentrales(centrales);
                 4:borrardemandas(demandas);
                 5:modificarcentrales(centrales);
                 6:modificardemandas(demandas);
                 7:listareolicas(centrales);
                 8:begin
                       mosmenor:=mostrar_menor(demandas);
                       writeln('La zona que menos consume en la Argentina es: ',mosmenor);
                       readkey;
                       clrscr;
                   end;
                 9:begin
                       demtotal:=demandatotal(demandas);
                       writeln('La demanda por encima de la latitud -35.705 es: ',demtotal:0:2);
                       readkey;
                       clrscr;
                   end;
                 10:begin
                       prodtotal:=produccion_total(centrales);
                       writeln('La produccion en el cuadrante (lat/long) (-31,-60), (-20,-60), (-31,-70), (-20,-70) es: ',prodtotal:0:2);
                       readkey;
                       clrscr;
                   end;
                 11:listarmax(centrales);
                 12:listarsolar(centrales);
                end;
        until (opcion=13);
end;
var
        centralener:tcentralener;
        demanda:tdemanda;
begin   {inicio de programa}
        clrscr;
        iniciarcentrales(centralener);
        iniciardemandas(demanda);
        precargarcentrales(centralener);
        precargademanda(demanda);
        menu(demanda,centralener);
        writeln('Gracias por usar el programa');
        readkey;
end.
