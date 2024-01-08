CREATE EXTENSION IF NOT EXISTS ltree;
-- 先判断表是否存在，如果存在则删除
DROP TABLE IF EXISTS tree;
DROP TABLE IF EXISTS Policyholders;

-- 然后创建新表
CREATE TABLE Policyholders
(
    PolicyholderID varchar PRIMARY KEY,
    Name           VARCHAR(255),
    JoinDate       DATE,
    ReferrerID     varchar,
    FOREIGN KEY (ReferrerID) REFERENCES Policyholders (PolicyholderID)
);


-- 然后创建新表
CREATE TABLE tree
(
    policyholderID varchar,
    path           LTREE,
    FOREIGN KEY (policyholderID) REFERENCES Policyholders (PolicyholderID)
);

insert into policyholders (policyholderid, name, joindate, referrerid)
values ('000001', 'Name 1', '2021-09-14', null),
       ('000003', 'Name 3', '2023-05-08', '000001'),
       ('000013', 'Name 13', '2023-06-22', '000010'),
       ('000005', 'Name 5', '2023-08-13', '000001'),
       ('000020', 'Name 20', '2021-08-14', '000011'),
       ('000008', 'Name 8', '2023-11-12', '000006'),
       ('000010', 'Name 10', '2023-11-12', '000008'),
       ('000019', 'Name 19', '2023-02-10', '000015'),
       ('000012', 'Name 12', '2023-04-20', '000008'),
       ('000017', 'Name 17', '2023-12-25', '000009'),
       ('000011', 'Name 11', '2023-03-04', '000010'),
       ('000002', 'Name 2', '2022-10-26', '000001'),
       ('000014', 'Name 14', '2021-12-01', '000011'),
       ('000004', 'Name 4', '2022-12-13', '000001'),
       ('000016', 'Name 16', '2021-06-08', '000003'),
       ('000015', 'Name 15', '2023-01-09', '000014'),
       ('000007', 'Name 7', '2023-07-29', '000006'),
       ('000009', 'Name 9', '2021-11-03', '000006'),
       ('000006', 'Name 6', '2021-08-22', '000004'),
       ('000018', 'Name 18', '2023-04-25', '000007');

INSERT INTO public.tree (policyholderid, path) VALUES ('000001', '1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000003', '1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000005', '1.2'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000004', '1.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000006', '1.1.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000007', '1.1.1.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000008', '1.1.1.1.2'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000009', '1.1.1.1.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000018', '1.1.1.1.1.2'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000010', '1.1.1.1.2.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000012', '1.1.1.1.2.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000017', '1.1.1.1.1.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000011', '1.1.1.1.2.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000013', '1.1.1.1.2.1.2'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000014', '1.1.1.1.2.1.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000020', '1.1.1.1.2.1.1.2'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000015', '1.1.1.1.2.1.1.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000019', '1.1.1.1.2.1.1.1.1.1'::ltree);
INSERT INTO public.tree (policyholderid, path) VALUES ('000002', '1.1.1.1.2.1.1.1.1.1.1'::ltree);


-- insert into policyholders (policyholderid, name, joindate, referrerid)
-- values (1, 'Name 1', '2021-09-14', null),
--        (3, 'Name 3', '2023-05-08', 1),
--        (13, 'Name 13', '2023-06-22', 10),
--        (5, 'Name 5', '2023-08-13', 1),
--        (20, 'Name 20', '2021-08-14', 11),
--        (8, 'Name 8', '2023-11-12', 6),
--        (10, 'Name 10', '2023-11-12', 8),
--        (19, 'Name 19', '2023-02-10', 15),
--        (12, 'Name 12', '2023-04-20', 8),
--        (17, 'Name 17', '2023-12-25', 9),
--        (11, 'Name 11', '2023-03-04', 10),
--        (2, 'Name 2', '2022-10-26', 1),
--        (14, 'Name 14', '2021-12-01', 11),
--        (4, 'Name 4', '2022-12-13', 1),
--        (16, 'Name 16', '2021-06-08', 3),
--        (15, 'Name 15', '2023-01-09', 14),
--        (7, 'Name 7', '2023-07-29', 6),
--        (9, 'Name 9', '2021-11-03', 6),
--        (6, 'Name 6', '2021-08-22', 4),
--        (18, 'Name 18', '2023-04-25', 7);
--
-- INSERT INTO public.tree (policyholderid, path) VALUES (1, '1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (3, '1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (5, '1.2'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (4, '1.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (6, '1.1.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (7, '1.1.1.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (8, '1.1.1.1.2'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (9, '1.1.1.1.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (18, '1.1.1.1.1.2'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (10, '1.1.1.1.2.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (12, '1.1.1.1.2.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (17, '1.1.1.1.1.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (11, '1.1.1.1.2.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (13, '1.1.1.1.2.1.2'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (14, '1.1.1.1.2.1.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (20, '1.1.1.1.2.1.1.2'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (15, '1.1.1.1.2.1.1.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (19, '1.1.1.1.2.1.1.1.1.1'::ltree);
-- INSERT INTO public.tree (policyholderid, path) VALUES (2, '1.1.1.1.2.1.1.1.1.1.1'::ltree);
