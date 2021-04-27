CREATE or Alter PROCEDURE [Staging].[exec_qa_tests] 
	-- Add the parameters for the stored procedure here
	@code varchar(15),
	@dev varchar(15), 
	@date date='1900-01-01'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @enabled varchar(2)
	declare @parameter varchar(20)
	declare @test_sql varchar(max)

	declare @_dev varchar(max)
	set @_dev=concat('_',@dev)

	declare @_date varchar(max)
	set @_date=concat('=','''',@date,'''')

	set @enabled=(select enabled from [Staging].[qa_tests] where code=@code)
	set @parameter=(select parameter from [Staging].[qa_tests] where code=@code)
	
	--replace the env and date part from the test_sql with the passed values from the procedure, also convert double spaces to single space
	set @test_sql=replace(replace(replace(replace(replace(replace((select test_sql from [Staging].[qa_tests] where code=@code),'_env',@_dev),' ','<>'),'><',''),'<>',' '),'= ','='),'=date',@_date)
	

	--find number of parameters to passed to the procedure
	declare @reqnumberofparams int=(LEN(@parameter) - LEN(REPLACE(@parameter,',','')) + 1)

	-- print details of below variables
	SELECT code=@code
			,dev=@dev
			,date=@date
			,reqnumberofparams=@reqnumberofparams
			,enabled=@enabled
			,parameter=@parameter
			,test_sql=@test_sql
			

	--execute the SQL only if enable flag is Y
	if 	@enabled='Y'
	BEGIN
		select concat('executing test_sql for code= ',@code)
		exec (@test_sql)
	END
	else
	BEGIN
		select concat('Test_sql is disabled for code= ',@code)
	END

END
GO
