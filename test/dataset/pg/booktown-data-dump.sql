--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: alternate_stock; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY alternate_stock (isbn, cost, retail, stock) FROM stdin;
0385121679	29.00	36.95	65
039480001X	30.00	32.95	31
0394900014	23.00	23.95	0
044100590X	36.00	45.95	89
0441172717	17.00	21.95	77
0451160916	24.00	28.95	22
0451198492	36.00	46.95	0
0451457994	17.00	22.95	0
0590445065	23.00	23.95	10
0679803335	20.00	24.95	18
0694003611	25.00	28.95	50
0760720002	18.00	23.95	28
0823015505	26.00	28.95	16
0929605942	19.00	21.95	25
1885418035	23.00	24.95	77
0394800753	16.00	16.95	4
\.


--
-- Name: author_ids; Type: SEQUENCE SET; Schema: public; Owner: ingy
--

SELECT pg_catalog.setval('author_ids', 25044, true);


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY authors (id, last_name, first_name) FROM stdin;
1111	Denham	Ariel
1212	Worsley	John
15990	Bourgeois	Paulette
25041	Bianco	Margery Williams
16	Alcott	Louisa May
4156	King	Stephen
1866	Herbert	Frank
1644	Hogarth	Burne
2031	Brown	Margaret Wise
115	Poe	Edgar Allen
7805	Lutz	Mark
7806	Christiansen	Tom
1533	Brautigan	Richard
1717	Brite	Poppy Z.
2112	Gorey	Edward
2001	Clarke	Arthur C.
1213	Brookins	Andrew
\.


--
-- Data for Name: book_backup; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY book_backup (id, title, author_id, subject_id) FROM stdin;
7808	The Shining	4156	9
4513	Dune	1866	15
4267	2001: A Space Odyssey	2001	15
1608	The Cat in the Hat	1809	2
1590	Bartholomew and the Oobleck	1809	2
25908	Franklin in the Dark	15990	2
1501	Goodnight Moon	2031	2
190	Little Women	16	6
1234	The Velveteen Rabbit	25041	3
2038	Dynamic Anatomy	1644	0
156	The Tell-Tale Heart	115	9
41472	Practical PostgreSQL	1212	4
41473	Programming Python	7805	4
41477	Learning Python	7805	4
41478	Perl Cookbook	7806	4
7808	The Shining	4156	9
4513	Dune	1866	15
4267	2001: A Space Odyssey	2001	15
1608	The Cat in the Hat	1809	2
1590	Bartholomew and the Oobleck	1809	2
25908	Franklin in the Dark	15990	2
1501	Goodnight Moon	2031	2
190	Little Women	16	6
1234	The Velveteen Rabbit	25041	3
2038	Dynamic Anatomy	1644	0
156	The Tell-Tale Heart	115	9
41473	Programming Python	7805	4
41477	Learning Python	7805	4
41478	Perl Cookbook	7806	4
41472	Practical PostgreSQL	1212	4
\.


--
-- Name: book_ids; Type: SEQUENCE SET; Schema: public; Owner: ingy
--

SELECT pg_catalog.setval('book_ids', 41478, true);


--
-- Data for Name: book_queue; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY book_queue (title, author_id, subject_id, approved) FROM stdin;
Learning Python	7805	4	t
Perl Cookbook	7806	4	t
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY books (id, title, author_id, subject_id) FROM stdin;
7808	The Shining	4156	9
4513	Dune	1866	15
4267	2001: A Space Odyssey	2001	15
1608	The Cat in the Hat	1809	2
1590	Bartholomew and the Oobleck	1809	2
25908	Franklin in the Dark	15990	2
1501	Goodnight Moon	2031	2
190	Little Women	16	6
1234	The Velveteen Rabbit	25041	3
2038	Dynamic Anatomy	1644	0
156	The Tell-Tale Heart	115	9
41473	Programming Python	7805	4
41477	Learning Python	7805	4
41478	Perl Cookbook	7806	4
41472	Practical PostgreSQL	1212	4
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY customers (id, last_name, first_name) FROM stdin;
107	Jackson	Annie
112	Gould	Ed
142	Allen	Chad
146	Williams	James
172	Brown	Richard
185	Morrill	Eric
221	King	Jenny
270	Bollman	Julie
388	Morrill	Royce
409	Holloway	Christine
430	Black	Jean
476	Clark	James
480	Thomas	Rich
488	Young	Trevor
574	Bennett	Laura
652	Anderson	Jonathan
655	Olson	Dave
671	Brown	Chuck
723	Eisele	Don
724	Holloway	Adam
738	Gould	Shirley
830	Robertson	Royce
853	Black	Wendy
860	Owens	Tim
880	Robinson	Tammy
898	Gerdes	Kate
964	Gould	Ramon
1045	Owens	Jean
1125	Bollman	Owen
1149	Becker	Owen
1123	Corner	Kathy
\.


--
-- Data for Name: daily_inventory; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY daily_inventory (isbn, is_stocked) FROM stdin;
039480001X	t
044100590X	t
0451198492	f
0394900014	f
0441172717	t
0451160916	f
0385121679	\N
\.


--
-- Data for Name: distinguished_authors; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY distinguished_authors (id, last_name, first_name, award) FROM stdin;
25043	Simon	Neil	Pulitzer Prize
1809	Geisel	Theodor Seuss	Pulitzer Prize
\.


--
-- Data for Name: editions; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY editions (isbn, book_id, edition, publisher_id, publication, type) FROM stdin;
039480001X	1608	1	59	1957-03-01	h
0451160916	7808	1	75	1981-08-01	p
0394800753	1590	1	59	1949-03-01	p
0590445065	25908	1	150	1987-03-01	p
0694003611	1501	1	65	1947-03-04	p
0679803335	1234	1	102	1922-01-01	p
0760720002	190	1	91	1868-01-01	p
0394900014	1608	1	59	1957-01-01	p
0385121679	7808	2	75	1993-10-01	h
1885418035	156	1	163	1995-03-28	p
0929605942	156	2	171	1998-12-01	p
0441172717	4513	2	99	1998-09-01	p
044100590X	4513	3	99	1999-10-01	h
0451457994	4267	3	101	2000-09-12	p
0451198492	4267	3	101	1999-10-01	h
0823015505	2038	1	62	1958-01-01	p
0596000855	41473	2	113	2001-03-01	p
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY employees (id, last_name, first_name) FROM stdin;
101	Appel	Vincent
102	Holloway	Michael
105	Connoly	Sarah
104	Noble	Ben
103	Joble	David
106	Hall	Timothy
1008	Williams	\N
\.


--
-- Data for Name: favorite_authors; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY favorite_authors (employee_id, authors_and_titles) FROM stdin;
102	{{"J.R.R. Tolkien","The Silmarillion"},{"Charles Dickens","Great Expectations"},{"Ariel Denham","Attic Lives"}}
\.


--
-- Data for Name: favorite_books; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY favorite_books (employee_id, books) FROM stdin;
102	{"The Hitchhiker's Guide to the Galaxy","The Restauraunt at the End of the Universe"}
103	{"There and Back Again: A Hobbit's Holiday","Kittens Squared"}
\.


--
-- Data for Name: money_example; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY money_example (money_cash, numeric_cash) FROM stdin;
$12.24	12.24
\.


--
-- Data for Name: my_list; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY my_list (todos) FROM stdin;
Pick up laundry.
Send out bills.
Wrap up Grand Unifying Theory for publication.
\.


--
-- Data for Name: numeric_values; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY numeric_values (num) FROM stdin;
68719476736.000000
68719476737.000000
6871947673778.000000
999999999999999999999999.999900
999999999999999999999999.999999
-999999999999999999999999.999999
-100000000000000000000000.999999
1.999999
2.000000
2.000000
999999999999999999999999.999999
999999999999999999999999.000000
\.


--
-- Data for Name: publishers; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY publishers (id, name, address) FROM stdin;
\.


--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY schedules (employee_id, schedule) FROM stdin;
102	Mon - Fri, 9am - 5pm
\.


--
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY shipments (id, customer_id, isbn, ship_date) FROM stdin;
375	142	039480001X	2001-08-06 12:29:21-04
323	671	0451160916	2001-08-14 13:36:41-04
998	1045	0590445065	2001-08-12 15:09:47-04
749	172	0694003611	2001-08-11 13:52:34-04
662	655	0679803335	2001-08-09 10:30:07-04
806	1125	0760720002	2001-08-05 12:34:04-04
102	146	0394900014	2001-08-11 16:34:08-04
813	112	0385121679	2001-08-08 12:53:46-04
652	724	1885418035	2001-08-14 16:41:39-04
599	430	0929605942	2001-08-10 11:29:42-04
969	488	0441172717	2001-08-14 11:42:58-04
433	898	044100590X	2001-08-12 11:46:35-04
660	409	0451457994	2001-08-07 14:56:42-04
310	738	0451198492	2001-08-15 17:02:01-04
510	860	0823015505	2001-08-14 10:33:47-04
997	185	039480001X	2001-08-10 16:47:52-04
999	221	0451160916	2001-08-14 16:45:51-04
56	880	0590445065	2001-08-14 16:49:00-04
72	574	0694003611	2001-08-06 10:49:44-04
146	270	039480001X	2001-08-13 12:42:10-04
981	652	0451160916	2001-08-08 11:36:44-04
95	480	0590445065	2001-08-10 10:29:52-04
593	476	0694003611	2001-08-15 14:57:40-04
977	853	0679803335	2001-08-09 12:30:46-04
117	185	0760720002	2001-08-07 16:00:48-04
406	1123	0394900014	2001-08-13 12:47:04-04
340	1149	0385121679	2001-08-12 16:39:22-04
871	388	1885418035	2001-08-07 14:31:57-04
1000	221	039480001X	2001-09-14 19:46:32-04
1001	107	039480001X	2001-09-14 20:42:22-04
754	107	0394800753	2001-08-11 12:55:05-04
458	107	0394800753	2001-08-07 13:58:36-04
189	107	0394800753	2001-08-06 14:46:36-04
720	107	0394800753	2001-08-08 13:46:13-04
1002	107	0394800753	2001-09-22 14:23:28-04
2	107	0394800753	2001-09-22 23:58:56-04
\.


--
-- Name: shipments_ship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ingy
--

SELECT pg_catalog.setval('shipments_ship_id_seq', 1011, true);


--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY states (id, name, abbreviation) FROM stdin;
42	Washington	WA
51	Oregon	OR
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY stock (isbn, cost, retail, stock) FROM stdin;
0385121679	29.00	36.95	65
039480001X	30.00	32.95	31
0394900014	23.00	23.95	0
044100590X	36.00	45.95	89
0441172717	17.00	21.95	77
0451160916	24.00	28.95	22
0451198492	36.00	46.95	0
0451457994	17.00	22.95	0
0590445065	23.00	23.95	10
0679803335	20.00	24.95	18
0694003611	25.00	28.95	50
0760720002	18.00	23.95	28
0823015505	26.00	28.95	16
0929605942	19.00	21.95	25
1885418035	23.00	24.95	77
0394800753	16.00	16.95	4
\.


--
-- Data for Name: stock_backup; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY stock_backup (isbn, cost, retail, stock) FROM stdin;
0385121679	29.00	36.95	65
039480001X	30.00	32.95	31
0394800753	16.00	16.95	0
0394900014	23.00	23.95	0
044100590X	36.00	45.95	89
0441172717	17.00	21.95	77
0451160916	24.00	28.95	22
0451198492	36.00	46.95	0
0451457994	17.00	22.95	0
0590445065	23.00	23.95	10
0679803335	20.00	24.95	18
0694003611	25.00	28.95	50
0760720002	18.00	23.95	28
0823015505	26.00	28.95	16
0929605942	19.00	21.95	25
1885418035	23.00	24.95	77
\.


--
-- Name: subject_ids; Type: SEQUENCE SET; Schema: public; Owner: ingy
--

SELECT pg_catalog.setval('subject_ids', 15, true);


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY subjects (id, subject, location) FROM stdin;
0	Arts	Creativity St
1	Business	Productivity Ave
2	Children's Books	Kids Ct
3	Classics	Academic Rd
4	Computers	Productivity Ave
5	Cooking	Creativity St
6	Drama	Main St
7	Entertainment	Main St
8	History	Academic Rd
9	Horror	Black Raven Dr
10	Mystery	Black Raven Dr
11	Poetry	Sunset Dr
12	Religion	\N
13	Romance	Main St
14	Science	Productivity Ave
15	Science Fiction	Main St
\.


--
-- Data for Name: text_sorting; Type: TABLE DATA; Schema: public; Owner: ingy
--

COPY text_sorting (letter) FROM stdin;
0
1
2
3
A
B
C
D
a
b
c
d
\.


--
-- PostgreSQL database dump complete
--

