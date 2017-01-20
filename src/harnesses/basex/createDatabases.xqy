<c:query xmlns:c="http://www.w3.org/ns/xproc-step">
xquery version "3.0" encoding "utf-8";

declare namespace db="http://basex.org/modules/db";
declare namespace x="http://www.jenitennison.com/xslt/xspec";
declare namespace dbs="http://els.eu/ns/efl/offresMetiers/BaseX/DatabaseStructure";

(: Parcours des scenarii de test de fonctions :)
for $s in (//x:scenario[x:call[@function]])
	let $index := count($s/preceding::x:scenario)+1
	let $db_params := $s/x:call/x:param[starts-with(@as, 'element(dbs:') or 
										starts-with(*[1]/name(), 'dbs:')]
	for $db_param in $db_params
		let $db_element := $db_param/*[1]
		let $db_name := concat($db_element/@name, '_', $index)
		let $db_res := $db_element/descendant-or-self::dbs:resource
		return
			(db:output(concat('Création de la base ', $db_name)), 
			 db:create($db_name, $db_res/*, $db_res/@path))
</c:query>