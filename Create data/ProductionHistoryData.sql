INSERT INTO dbo.ProductionHistory (employeeId, productId, status, startDate)
VALUES
/* Anna Johnson (2) – иногда 2 статуса, иногда 3 */
(2,  1, 'Started',    '2025-01-06T08:00:00'),
(2,  1, 'Completed',  '2025-01-06T10:05:00'),  -- Office chair ~2h

(2,  3, 'Started',    '2025-01-07T08:10:00'),
(2,  3, 'Extra time', '2025-01-07T12:30:00'),
(2,  3, 'Completed',  '2025-01-07T13:00:00'),  -- Office desk ~4h + extra

(2, 18, 'Started',    '2025-01-08T08:05:00'),
(2, 18, 'Completed',  '2025-01-08T10:40:00'),  -- Basic student desk ~2.5h

(2, 20, 'Started',    '2025-01-09T08:00:00'),
(2, 20, 'Extra time', '2025-01-09T11:20:00'),
(2, 20, 'Completed',  '2025-01-09T11:50:00'),  -- Standing desk ~3h + extra

/* Michael Brown (3) */
(3,  4, 'Started',    '2025-01-06T12:15:00'),
(3,  4, 'Completed',  '2025-01-06T17:20:00'),  -- Gaming desk ~5h

(3, 17, 'Started',    '2025-01-07T12:05:00'),
(3, 17, 'Extra time', '2025-01-07T18:45:00'),
(3, 17, 'Completed',  '2025-01-07T19:10:00'),  -- Electric adj desk ~6.5h + extra

(3, 21, 'Started',    '2025-01-08T12:00:00'),
(3, 21, 'Completed',  '2025-01-08T15:05:00'),  -- Ergo swivel chair ~3h

/* Emily Davis (4) */
(4,  9, 'Started',    '2025-01-06T08:05:00'),
(4,  9, 'Completed',  '2025-01-06T09:50:00'),  -- Simple chair ~1h40

(4, 11, 'Started',    '2025-01-07T08:10:00'),
(4, 11, 'Extra time', '2025-01-07T10:40:00'),
(4, 11, 'Completed',  '2025-01-07T10:55:00'),  -- Wall-mounted desk ~2h10 + extra

(4, 15, 'Started',    '2025-01-08T08:00:00'),
(4, 15, 'Completed',  '2025-01-08T09:15:00'),  -- Plastic student chair ~1h10

/* Peter Miller (5) */
(5,  5, 'Started',    '2025-01-06T08:15:00'),
(5,  5, 'Completed',  '2025-01-06T09:50:00'),  -- Projector stand ~1h30

(5, 19, 'Started',    '2025-01-07T08:05:00'),
(5, 19, 'Extra time', '2025-01-07T12:00:00'),
(5, 19, 'Completed',  '2025-01-07T12:30:00'),  -- Mobile projector cart ~3h40 + extra

(5, 25, 'Started',    '2025-01-08T08:30:00'),
(5, 25, 'Completed',  '2025-01-08T10:40:00'),  -- Wall projector mount ~2h

/* John Smith (1) */
(1,  6, 'Started',    '2025-01-08T08:10:00'),
(1,  6, 'Completed',  '2025-01-08T11:45:00'),  -- Executive chair ~3h30

(1, 16, 'Started',    '2025-01-09T08:00:00'),
(1, 16, 'Extra time', '2025-01-09T12:45:00'),
(1, 16, 'Completed',  '2025-01-09T13:00:00'),  -- Adjustable office desk ~4h30 + extra

(1, 22, 'Started',    '2025-01-10T08:05:00'),
(1, 22, 'Completed',  '2025-01-10T12:20:00'),  -- Wood-metal hybrid desk ~4h10

/* Sarah Wilson (6) */
(6, 13, 'Started',    '2025-01-09T08:20:00'),
(6, 13, 'Completed',  '2025-01-09T12:50:00'),  -- Interactive board stand ~4h20

(6, 23, 'Started',    '2025-01-10T08:15:00'),
(6, 23, 'Extra time', '2025-01-10T13:40:00'),
(6, 23, 'Completed',  '2025-01-10T14:10:00'),  -- Whiteboard frame ~5h10 + extra

(6, 19, 'Started',    '2025-01-13T08:10:00'),
(6, 19, 'Completed',  '2025-01-13T11:55:00'),  -- Mobile projector cart ~3h40

/* David Taylor (7) */
(7, 24, 'Started',    '2025-01-10T08:30:00'),
(7, 24, 'Completed',  '2025-01-10T12:25:00'),  -- Conf table ~3h50

(7, 26, 'Started',    '2025-01-13T08:05:00'),
(7, 26, 'Extra time', '2025-01-13T12:50:00'),
(7, 26, 'Completed',  '2025-01-13T13:20:00'),  -- Teacher workstation ~4h40 + extra

(7,  3, 'Started',    '2025-01-14T08:15:00'),
(7,  3, 'Completed',  '2025-01-14T12:20:00'),  -- Office desk ~4h

/* Olivia Moore (8) – после 12:00 */
(8,  2, 'Started',    '2025-01-08T12:10:00'),
(8,  2, 'Completed',  '2025-01-08T15:20:00'),  -- Gaming chair ~3h

(8,  8, 'Started',    '2025-01-15T12:05:00'),
(8,  8, 'Extra time', '2025-01-15T18:10:00'),
(8,  8, 'Completed',  '2025-01-15T18:30:00'),  -- Premium gaming desk ~5h50 + extra

(8, 11, 'Started',    '2025-01-22T12:00:00'),
(8, 11, 'Completed',  '2025-01-22T14:15:00');  -- Wall-mounted desk ~2h10
GO