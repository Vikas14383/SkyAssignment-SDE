

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[qa_tests]') AND type in (N'U'))
DROP TABLE [Staging].[qa_tests]
GO


CREATE TABLE [Staging].[qa_tests](
	[code] [varchar](10) NOT NULL,
	[description] [varchar](255) NOT NULL,
	[enabled] [varchar](2) NOT NULL,
	[parameter] [varchar](50) NOT NULL,
	[test_sql] [varchar](max) NOT NULL,
	[exp_result] [varchar](2) NOT NULL
) 
GO


INSERT INTO [Staging].[qa_tests]
           ([code]
           ,[description]
           ,[enabled]
           ,[parameter]
           ,[test_sql]
           ,[exp_result])
     VALUES
           ('qa_ch_01'
           ,'Runs the SQL against the Channel table to count duplicates. Duplicates count must be 0'
           ,'Y'
           ,'env'
           ,'Select count (*) from (select channel_code, count (*) from channel_table_env group by channel_code having count(*) > 1)'
           ,'0')

INSERT INTO [Staging].[qa_tests]
           ([code]
           ,[description]
           ,[enabled]
           ,[parameter]
           ,[test_sql]
           ,[exp_result])
     VALUES
           ('qa_ch_02'
           ,'Check the FK between channel_code and its child table channel_transaction to identify orphans at a given date'
           ,'Y'
           ,'env,date'
           ,'select count (*) from channel_transaction_env A left join channel_table_env B on (A.channel_code = B.channel_code) where B.channel_code is null and B.transaction_date = date'
           ,'0')

INSERT INTO [Staging].[qa_tests]
           ([code]
           ,[description]
           ,[enabled]
           ,[parameter]
           ,[test_sql]
           ,[exp_result])
     VALUES
           ('qa_ch_03'
           ,'Counts the records in channel_transaction table at a given date that have amount null'
           ,'N'
           ,'date'
           ,'select count(*) from channel_transaction_env where transaction_date =date and transaction_amount is null'
           ,'0')

