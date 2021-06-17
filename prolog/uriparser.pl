:- module(
  uriparser,
  [
    check_iri/1,   % +Iri
    check_uri/1,   % +Uri
    is_http_uri/1, % @Term
    is_iri/1,      % @Term
    is_uri/1,      % @Term
    resolve_uri/3, % +Base, +Relative, ?Absolute
    uri_scheme/1   % ?Scheme
  ]
).
:- reexport(library(uri)).

/** <module> Prolog uriparser binding

*/

:- use_module(library(shlib)).

:- use_foreign_library(foreign(uriparser)).





%! check_iri(+Iri:atom) is semidet.
%
% Succeeds iff `Iri' is an absolute IRI.
%
% TODO: Only checking for URI compliance ATM.

check_iri(Iri) :-
  uri_iri(Uri, Iri),
  check_uri(Uri).



%! check_uri(+Uri:atom) is semidet.
%
% Succeeds iff `Uri' is an absolute URI.
%
% @throws existence_error(uri_scheme,Scheme:atom)

check_uri(Uri) :-
  uri_components(Uri, uri_components(Scheme,Auth,Path,_,_)),
  check_scheme_(Scheme, Uri),
  scheme_specific_checks(Uri, Scheme, Auth, Path),
  is_uri_(Uri).

check_scheme_(Scheme, _) :-
  uri_scheme(Scheme), !.
check_scheme_(Schema, Uri) :-
  throw(error(existence_error(uri_scheme,Schema),Uri)).

scheme_specific_checks(_, Scheme, Auth, Path) :-
  (   % URI schemes that require a ground authority component.
      memberchk(Scheme, [http,https])
  ->  ground(Auth)
  ;   % URI schemes that require a ground path component.
      memberchk(Scheme, [file,mailto,urn])
  ->  ground(Path)
  ;   true
  ), !.
scheme_specific_checks(Uri, _, _, _) :-
  syntax_error(grammar(uri,Uri)).



%! is_http_uri(@Term) is semidet.
%
% Succeeds iff Term is an atom that conforms to the URI grammar.

is_http_uri(Uri) :-
  is_uri(Uri),
  uri_components(Uri, Comps),
  uri_data(scheme, Comps, Scheme),
  memberchk(Scheme, [http,https]).



%! is_iri(@Term) is semidet.

is_iri(Term) :-
  catch(check_iri(Term), E, print_message(warning, E)),
  var(E).



%! is_uri(@Term) is semidet.

is_uri(Term) :-
  catch(check_uri(Term), E, print_message(warning, E)),
  var(E).



%! resolve_uri(+Base:atom, +Relative:atom, +Absolute:atom) is semidet.
%! resolve_uri(+Base:atom, +Relative:atom, -Absolute:atom) is det.

resolve_uri(Base, Relative, Absolute) :-
  resolve_uri_(Base, Relative, Absolute).



%! uri_scheme(+Schema:atom) is semidet.
%! uri_scheme(-Schema:atom) is nondet.
%
% Succeeds for all and only atoms that denote an URI schema as
% registered by IANA.
%
% @see https://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml).
%
% @version Last synchronized on 2020-04-13 with the following code:
%
% ```pl
% [library(http/http_open)].
% http_open('https://www.iana.org/assignments/uri-schemes/uri-schemes-1.csv', In, []),
% csv_read_stream(In, Rows, []),
% member(Row, Rows),
% Row =.. [row,H|_],
% write_canonical(H),
% nl,
% fail.
% ```

uri_scheme(aaa).
uri_scheme(aaas).
uri_scheme(about).
uri_scheme(acap).
uri_scheme(acct).
uri_scheme(acd).
uri_scheme(acr).
uri_scheme(adiumxtra).
uri_scheme(adt).
uri_scheme(afp).
uri_scheme(afs).
uri_scheme(aim).
uri_scheme(amss).
uri_scheme(android).
uri_scheme(appdata).
uri_scheme(apt).
uri_scheme(ark).
uri_scheme(attachment).
uri_scheme(aw).
uri_scheme(barion).
uri_scheme(beshare).
uri_scheme(bitcoin).
uri_scheme(bitcoincash).
uri_scheme(blob).
uri_scheme(bolo).
uri_scheme(browserext).
uri_scheme(calculator).
uri_scheme(callto).
uri_scheme(cap).
uri_scheme(cast).
uri_scheme(casts).
uri_scheme(chrome).
uri_scheme('chrome-extension').
uri_scheme(cid).
uri_scheme(coap).
uri_scheme('coap+tcp').
uri_scheme('coap+ws').
uri_scheme(coaps).
uri_scheme('coaps+tcp').
uri_scheme('coaps+ws').
uri_scheme('com-eventbrite-attendee').
uri_scheme(content).
uri_scheme(conti).
uri_scheme(crid).
uri_scheme(cvs).
uri_scheme(dab).
uri_scheme(data).
uri_scheme(dav).
uri_scheme(diaspora).
uri_scheme(dict).
uri_scheme(did).
uri_scheme(dis).
uri_scheme('dlna-playcontainer').
uri_scheme('dlna-playsingle').
uri_scheme(dns).
uri_scheme(dntp).
uri_scheme(dpp).
uri_scheme(drm).
uri_scheme(drop).
uri_scheme(dtmi).
uri_scheme(dtn).
uri_scheme(dvb).
uri_scheme(ed2k).
uri_scheme(elsi).
uri_scheme(example).
uri_scheme(facetime).
uri_scheme(fax).
uri_scheme(feed).
uri_scheme(feedready).
uri_scheme(file).
uri_scheme(filesystem).
uri_scheme(finger).
uri_scheme('first-run-pen-experience').
uri_scheme(fish).
uri_scheme(fm).
uri_scheme(ftp).
uri_scheme('fuchsia-pkg').
uri_scheme(geo).
uri_scheme(gg).
uri_scheme(git).
uri_scheme(gizmoproject).
uri_scheme(go).
uri_scheme(gopher).
uri_scheme(graph).
uri_scheme(gtalk).
uri_scheme(h323).
uri_scheme(ham).
uri_scheme(hcap).
uri_scheme(hcp).
uri_scheme(http).
uri_scheme(https).
uri_scheme(hxxp).
uri_scheme(hxxps).
uri_scheme(hydrazone).
uri_scheme(iax).
uri_scheme(icap).
uri_scheme(icon).
uri_scheme(im).
uri_scheme(imap).
uri_scheme(info).
uri_scheme(iotdisco).
uri_scheme(ipn).
uri_scheme(ipp).
uri_scheme(ipps).
uri_scheme(irc).
uri_scheme(irc6).
uri_scheme(ircs).
uri_scheme(iris).
uri_scheme('iris.beep').
uri_scheme('iris.lwz').
uri_scheme('iris.xpc').
uri_scheme('iris.xpcs').
uri_scheme(isostore).
uri_scheme(itms).
uri_scheme(jabber).
uri_scheme(jar).
uri_scheme(jms).
uri_scheme(keyparc).
uri_scheme(lastfm).
uri_scheme(ldap).
uri_scheme(ldaps).
uri_scheme(leaptofrogans).
uri_scheme(lorawan).
uri_scheme(lvlt).
uri_scheme(magnet).
uri_scheme(mailserver).
uri_scheme(mailto).
uri_scheme(maps).
uri_scheme(market).
uri_scheme(message).
uri_scheme('microsoft.windows.camera').
uri_scheme('microsoft.windows.camera.multipicker').
uri_scheme('microsoft.windows.camera.picker').
uri_scheme(mid).
uri_scheme(mms).
uri_scheme(modem).
uri_scheme(mongodb).
uri_scheme(moz).
uri_scheme('ms-access').
uri_scheme('ms-browser-extension').
uri_scheme('ms-calculator').
uri_scheme('ms-drive-to').
uri_scheme('ms-enrollment').
uri_scheme('ms-excel').
uri_scheme('ms-eyecontrolspeech').
uri_scheme('ms-gamebarservices').
uri_scheme('ms-gamingoverlay').
uri_scheme('ms-getoffice').
uri_scheme('ms-help').
uri_scheme('ms-infopath').
uri_scheme('ms-inputapp').
uri_scheme('ms-lockscreencomponent-config').
uri_scheme('ms-media-stream-id').
uri_scheme('ms-mixedrealitycapture').
uri_scheme('ms-mobileplans').
uri_scheme('ms-officeapp').
uri_scheme('ms-people').
uri_scheme('ms-project').
uri_scheme('ms-powerpoint').
uri_scheme('ms-publisher').
uri_scheme('ms-restoretabcompanion').
uri_scheme('ms-screenclip').
uri_scheme('ms-screensketch').
uri_scheme('ms-search').
uri_scheme('ms-search-repair').
uri_scheme('ms-secondary-screen-controller').
uri_scheme('ms-secondary-screen-setup').
uri_scheme('ms-settings').
uri_scheme('ms-settings-airplanemode').
uri_scheme('ms-settings-bluetooth').
uri_scheme('ms-settings-camera').
uri_scheme('ms-settings-cellular').
uri_scheme('ms-settings-cloudstorage').
uri_scheme('ms-settings-connectabledevices').
uri_scheme('ms-settings-displays-topology').
uri_scheme('ms-settings-emailandaccounts').
uri_scheme('ms-settings-language').
uri_scheme('ms-settings-location').
uri_scheme('ms-settings-lock').
uri_scheme('ms-settings-nfctransactions').
uri_scheme('ms-settings-notifications').
uri_scheme('ms-settings-power').
uri_scheme('ms-settings-privacy').
uri_scheme('ms-settings-proximity').
uri_scheme('ms-settings-screenrotation').
uri_scheme('ms-settings-wifi').
uri_scheme('ms-settings-workplace').
uri_scheme('ms-spd').
uri_scheme('ms-sttoverlay').
uri_scheme('ms-transit-to').
uri_scheme('ms-useractivityset').
uri_scheme('ms-virtualtouchpad').
uri_scheme('ms-visio').
uri_scheme('ms-walk-to').
uri_scheme('ms-whiteboard').
uri_scheme('ms-whiteboard-cmd').
uri_scheme('ms-word').
uri_scheme(msnim).
uri_scheme(msrp).
uri_scheme(msrps).
uri_scheme(mss).
uri_scheme(mtqp).
uri_scheme(mumble).
uri_scheme(mupdate).
uri_scheme(mvn).
uri_scheme(news).
uri_scheme(nfs).
uri_scheme(ni).
uri_scheme(nih).
uri_scheme(nntp).
uri_scheme(notes).
uri_scheme(ocf).
uri_scheme(oid).
uri_scheme(onenote).
uri_scheme('onenote-cmd').
uri_scheme(opaquelocktoken).
uri_scheme(openpgp4fpr).
uri_scheme(pack).
uri_scheme(palm).
uri_scheme(paparazzi).
uri_scheme(payment).
uri_scheme(payto).
uri_scheme(pkcs11).
uri_scheme(platform).
uri_scheme(pop).
uri_scheme(pres).
uri_scheme(prospero).
uri_scheme(proxy).
uri_scheme(pwid).
uri_scheme(psyc).
uri_scheme(pttp).
uri_scheme(qb).
uri_scheme(query).
uri_scheme('quic-transport').
uri_scheme(redis).
uri_scheme(rediss).
uri_scheme(reload).
uri_scheme(res).
uri_scheme(resource).
uri_scheme(rmi).
uri_scheme(rsync).
uri_scheme(rtmfp).
uri_scheme(rtmp).
uri_scheme(rtsp).
uri_scheme(rtsps).
uri_scheme(rtspu).
uri_scheme(secondlife).
uri_scheme(service).
uri_scheme(session).
uri_scheme(sftp).
uri_scheme(sgn).
uri_scheme(shttp).
uri_scheme(sieve).
uri_scheme(simpleledger).
uri_scheme(sip).
uri_scheme(sips).
uri_scheme(skype).
uri_scheme(smb).
uri_scheme(sms).
uri_scheme(smtp).
uri_scheme(snews).
uri_scheme(snmp).
uri_scheme('soap.beep').
uri_scheme('soap.beeps').
uri_scheme(soldat).
uri_scheme(spiffe).
uri_scheme(spotify).
uri_scheme(ssh).
uri_scheme(steam).
uri_scheme(stun).
uri_scheme(stuns).
uri_scheme(submit).
uri_scheme(svn).
uri_scheme(tag).
uri_scheme(teamspeak).
uri_scheme(tel).
uri_scheme(teliaeid).
uri_scheme(telnet).
uri_scheme(tftp).
uri_scheme(things).
uri_scheme(thismessage).
uri_scheme(tip).
uri_scheme(tn3270).
uri_scheme(tool).
uri_scheme(turn).
uri_scheme(turns).
uri_scheme(tv).
uri_scheme(udp).
uri_scheme(unreal).
uri_scheme(urn).
uri_scheme(ut2004).
uri_scheme('v-event').
uri_scheme(vemmi).
uri_scheme(ventrilo).
uri_scheme(videotex).
uri_scheme(vnc).
uri_scheme('view-source').
uri_scheme(wais).
uri_scheme(webcal).
uri_scheme(wpid).
uri_scheme(ws).
uri_scheme(wss).
uri_scheme(wtai).
uri_scheme(wyciwyg).
uri_scheme(xcon).
uri_scheme('xcon-userid').
uri_scheme(xfire).
uri_scheme('xmlrpc.beep').
uri_scheme('xmlrpc.beeps').
uri_scheme(xmpp).
uri_scheme(xri).
uri_scheme(ymsgr).
uri_scheme('z39.50').
uri_scheme('z39.50r').
uri_scheme('z39.50s').
