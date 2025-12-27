INSERT INTO dbo.ProductElements (productID, elementID, quantity)
VALUES
/* 1 - Office chair */
(1,  1, 1),   -- Metal frame
(1,  2, 1),   -- Plastic seat
(1,  8, 1),   -- Plastic backrest
(1,  7, 2),   -- Armrests
(1,  5, 1),   -- Wheels set
(1,  4, 1),   -- Screws set
(1, 29, 1),   -- Bolt set (M6)
(1, 30, 1),   -- Nut & washer pack
(1, 17, 1),   -- Height adjustment mechanism
(1, 18, 1),   -- Shock absorber gas lift

/* 2 - Gaming chair */
(2,  1, 1),   -- Metal frame
(2,  2, 1),   -- Plastic seat
(2,  8, 1),   -- Plastic backrest
(2,  7, 2),   -- Armrests
(2,  5, 1),   -- Wheels set
(2,  4, 1),   -- Screws set
(2, 29, 1),   -- Bolt set (M6)
(2, 30, 1),   -- Nut & washer pack
(2, 15, 1),   -- Gaming seat padding
(2, 16, 1),   -- Ergonomic headrest
(2, 14, 1),   -- RGB LED strip
(2, 17, 1),   -- Height adjustment mechanism

/* 3 - Office desk */
(3,  1, 1),   -- Metal frame
(3,  3, 1),   -- Wooden desktop
(3,  6, 4),   -- Metal legs
(3,  4, 1),   -- Screws set
(3, 29, 1),   -- Bolt set (M6)
(3, 30, 1),   -- Nut & washer pack
(3, 11, 1),   -- Laminate surface panel
(3, 12, 2),   -- Desk cable grommet
(3, 31, 1),   -- Protective desk edging
(3, 32, 4),   -- Anti-slip desk pads

/* 4 - Gaming desk */
(4,  1, 1),   -- Metal frame
(4,  9, 2),   -- Steel reinforcement beam
(4, 10, 1),   -- Wooden tabletop (premium)
(4,  6, 4),   -- Metal legs
(4,  4, 1),   -- Screws set
(4, 29, 1),   -- Bolt set (M6)
(4, 30, 1),   -- Nut & washer pack
(4, 12, 3),   -- Desk cable grommet
(4, 14, 2),   -- RGB LED strip
(4, 27, 1),   -- Cable management tray
(4, 31, 1),   -- Protective desk edging

/* 5 - Projector stand */
(5,  1, 1),   -- Metal frame
(5,  6, 3),   -- Metal legs
(5, 20, 1),   -- Projector mounting plate
(5, 22, 1),   -- Telescopic metal arm
(5, 24, 4),   -- Caster wheel heavy-duty
(5, 26, 1),   -- Locking wheel system
(5,  4, 1),   -- Screws set
(5, 29, 1),   -- Bolt set
(5, 30, 1),   -- Nut & washer pack

/* 6 - Executive office chair */
(6,  1, 1),
(6,  2, 1),
(6,  8, 1),
(6,  7, 2),
(6,  5, 1),
(6,  4, 1),
(6, 29, 1),
(6, 30, 1),
(6, 16, 1),   -- Ergonomic headrest
(6, 17, 1),   -- Height adjustment mechanism
(6, 18, 1),   -- Shock absorber gas lift

/* 7 - Conference chair */
(7,  1, 1),
(7,  2, 1),
(7,  8, 1),
(7,  4, 1),
(7, 29, 1),
(7, 30, 1),
(7, 32, 4),   -- Anti-slip desk pads as chair feet

/* 8 - Premium gaming desk */
(8,  1, 1),
(8,  9, 3),
(8, 10, 1),
(8,  6, 4),
(8,  4, 1),
(8, 29, 1),
(8, 30, 1),
(8, 11, 1),
(8, 12, 4),
(8, 14, 3),
(8, 27, 1),
(8, 31, 1),

/* 9 - Simple chair */
(9,  1, 1),
(9,  2, 1),
(9,  8, 1),
(9,  4, 1),
(9, 29, 1),
(9, 30, 1),

/* 10 - Ergo office chair */
(10, 1, 1),
(10, 2, 1),
(10, 8, 1),
(10, 7, 2),
(10, 5, 1),
(10, 4, 1),
(10,29, 1),
(10,30, 1),
(10,16, 1),  -- Ergonomic headrest
(10,17, 1),  -- Height adjustment
(10,18, 1),  -- Shock absorber gas lift

/* 11 - Wall-mounted desk */
(11, 1, 1),
(11,  3, 1),
(11, 21, 2), -- Adjustable wall bracket
(11,  4, 1),
(11, 29, 1),
(11, 30, 1),
(11, 31, 1),

/* 12 - Laptop stand */
(12, 1, 1),
(12,11, 1),
(12,32, 4),
(12, 4, 1),
(12,29, 1),
(12,30, 1),

/* 13 - Interactive board stand */
(13, 1, 1),
(13,19, 1),  -- Whiteboard panel
(13,25, 1),  -- Mobile base frame
(13,24, 4),  -- Caster wheels
(13,26, 1),  -- Locking wheel system
(13, 4, 1),
(13,29, 1),
(13,30, 1),

/* 14 - Bar chair */
(14, 1, 1),
(14, 2, 1),
(14, 8, 1),
(14, 6, 4),  -- Metal legs / frame
(14, 4, 1),
(14,29, 1),
(14,30, 1),
(14,32, 4),

/* 15 - Plastic student chair */
(15, 1, 1),
(15, 2, 1),
(15, 8, 1),
(15, 4, 1),
(15,29, 1),
(15,30, 1),
(15,32, 4),

/* 16 - Adjustable office desk */
(16, 1, 1),
(16, 9, 2),
(16, 3, 1),
(16, 6, 4),
(16, 4, 1),
(16,29, 1),
(16,30, 1),
(16,12, 2),
(16,17, 1),  -- Height adjustment mechanism
(16,31, 1),
(16,32, 4),

/* 17 - Electric height-adjustable desk */
(17, 1, 1),
(17, 9, 3),
(17,10, 1),
(17, 6, 4),
(17, 4, 1),
(17,29, 1),
(17,30, 1),
(17,12, 3),
(17,17, 1),
(17,18, 2),  -- Stronger lift
(17,31, 1),
(17,32, 4),

/* 18 - Basic student desk */
(18, 1, 1),
(18, 3, 1),
(18, 6, 4),
(18, 4, 1),
(18,29, 1),
(18,30, 1),
(18,31, 1),

/* 19 - Mobile projector cart */
(19, 1, 1),
(19,25, 1),
(19,24, 4),
(19,26, 1),
(19,20, 1),
(19,22, 1),
(19,27, 1),
(19,33, 1),
(19, 4, 1),
(19,29, 1),
(19,30, 1),

/* 20 - Standing desk */
(20, 1, 1),
(20, 9, 1),
(20, 3, 1),
(20, 6, 4),
(20, 4, 1),
(20,29, 1),
(20,30, 1),
(20,31, 1),
(20,32, 4),

/* 21 - Ergonomic swivel chair */
(21, 1, 1),
(21, 2, 1),
(21, 8, 1),
(21, 7, 2),
(21, 5, 1),
(21, 4, 1),
(21,29, 1),
(21,30, 1),
(21,16, 1),
(21,17, 1),
(21,18, 1),

/* 22 - Wood-metal hybrid desk */
(22, 1, 1),
(22, 3, 1),
(22,10, 1),
(22, 9, 2),
(22, 6, 4),
(22, 4, 1),
(22,29, 1),
(22,30, 1),
(22,11, 1),
(22,31, 1),
(22,32, 4),

/* 23 - Interactive whiteboard frame */
(23, 1, 1),
(23,19, 1),
(23,21, 2),
(23,23, 1),  -- Interactive sensor module
(23, 4, 1),
(23,29, 1),
(23,30, 1),

/* 24 - Foldable conference table */
(24, 1, 1),
(24,10, 1),
(24, 9, 2),
(24, 6, 4),
(24,24, 4),
(24,26, 1),
(24, 4, 1),
(24,29, 1),
(24,30, 1),
(24,31, 1),

/* 25 - Wall projector mount */
(25,20, 1),
(25,21, 2),
(25,22, 1),
(25, 4, 1),
(25,29, 1),
(25,30, 1),
(25,33, 1),

/* 26 - Mobile teacher workstation */
(26, 1, 1),
(26, 3, 1),
(26, 6, 4),
(26,25, 1),
(26,24, 4),
(26,26, 1),
(26,27, 1),
(26,33, 1),
(26,13, 1),
(26, 4, 1),
(26,29, 1),
(26,30, 1),
(26,31, 1),

/* 27 - Cable management rack */
(27,27, 2),  -- Cable management tray
(27,28, 2),  -- Plastic rack holder
(27,33, 2),  -- Power strip bracket
(27, 4, 1),
(27,29, 1),
(27,30, 1);
GO