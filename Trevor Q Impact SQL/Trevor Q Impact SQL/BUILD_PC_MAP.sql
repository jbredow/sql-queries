

	build a two column PC X-Ref
	AAA6863.PR_MERGE_PC_COMPARE_NE
*/

-- changes number to string / hit on both sides
UPDATE AAA6863.PR_MERGE_PC_COMPARE_NE SET DEST_PC = LTRIM(TO_CHAR(DEST_PC,'000'));


-- junk below
select * from BMI2_DEST_MATR where ACCOUNT_NUMBER_NK = '2000';