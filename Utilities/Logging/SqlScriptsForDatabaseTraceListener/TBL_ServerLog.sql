/**************************************************************************************************
* PROJECT:		
*		Custom .NET Trace Listeners - Database Trace Listener

* SCRIPT NAME:	
*		TBL_ServerLog
* DESCRIPTION:  
*		Table that applications can log messages and data to.

* NOTES:		
*		.NET applications can write to this table via the custom database trace listener.  
*		T-SQL applications can write to this table via stored procedure p_SaveLogMessage.
***************************************************************************************************/
-- 			VISUAL SOURCESAFE REVISION LIST
--			===============================
-- $History: TBL_ServerLog.sql $.
-- 
-- *****************  Version 1  *****************
-- User: Simone       Date: 5/04/09    Time: 3:18p
-- Created in $/UtilitiesClassLibrary_DENG/Utilities.DatabaseLogging/SqlScriptsForDatabaseTraceListener
-- SQL script that creates a table that applications can log messages and
-- data to.
-- 
-- *****************  Version 4  *****************
-- User: Simone       Date: 16/02/09   Time: 4:03p
-- Updated in $/UtilitiesClassLibrary_DENG/Utilities.Logging/SqlScriptsForDatabaseTraceListener
-- Renamed TimeStamp column to RecordedDateTime which is not a reserved
-- word.
-- 
-- *****************  Version 3  *****************
-- User: Simone       Date: 12/06/08   Time: 2:29p
-- Updated in $/UtilitiesClassLibrary_DENG/Utilities.Logging/SqlScriptsForDatabaseTraceListener
-- Increase column size for Message and DetailedMessage columns.
-- 
-- *****************  Version 2  *****************
-- User: Simone       Date: 26/02/08   Time: 9:55a
-- Updated in $/UtilitiesClassLibrary_DENG/Utilities.Logging/SqlScriptsForDatabaseTraceListener
-- Remove USE statement from top of script so it will execute in the
-- current database, whichever database that is. 
-- 
-- *****************  Version 1  *****************
-- User: Simone       Date: 18/02/08   Time: 9:29a
-- Created in $/UtilitiesClassLibrary_DENG/Utilities.Logging/SqlScriptsForDatabaseTraceListener
-- ************************************************************************************************
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'ServerLog' AND type = 'U')
BEGIN
	DROP TABLE ServerLog
END
GO

CREATE TABLE dbo.ServerLog(
	LogMsgID int IDENTITY(1,1) NOT NULL,
	RecordedDateTime datetime NOT NULL CONSTRAINT DF_ServerLog_TimeStamp  DEFAULT (getdate()),
	Message nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DetailedMessage nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Category nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	EventID int NULL, 
	ProcedureName nvarchar(100) NULL, 
	Source nvarchar(100) NULL, 
	Application nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ProcessID int NULL, 
	ThreadID nvarchar(50) NULL, 
	RelatedActivityID nvarchar(50) NULL, 
	CallStack nvarchar(4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LogicalOperationStack nvarchar(4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
 CONSTRAINT PK_ServerLog PRIMARY KEY NONCLUSTERED 
(
	LogMsgID ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IDX_ServerLog_EventType
	ON ServerLog (Category)

CREATE NONCLUSTERED INDEX IDX_ServerLog_Source
	ON ServerLog (Source)

CREATE NONCLUSTERED INDEX IDX_ServerLog_Application
	ON ServerLog (Application)
GO

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'Unique identifer for each record in the server log.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'LogMsgID'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'The date & time the log record was recorded.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'TimeStamp'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'The log message.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'Message'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'Detailed failure message.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'DetailedMessage'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'A category that can be used to filter the log records or the type of event that recorded the record.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'Category'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'A unique identifier for the event that recorded the log entry.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'EventID'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'Name of the procedure or method that recorded the log entry.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'ProcedureName'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'The name of the source that recorded the log entry.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'Source'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'The name of the application that recorded the log entry.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'Application'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'Unique identifier for the current process.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'ProcessID'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'Unique identifier for the current managed thread.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'ThreadID'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'A Guid identifying a related activity.' , 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'RelatedActivityID'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'The call stack for the current thread.', 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'CallStack'

EXEC sys.sp_addextendedproperty 
		@name=N'MS_Description', 
		@value=N'Stack containing correlation data.', 
		@level0type=N'SCHEMA', 
		@level0name=N'dbo', 
		@level1type=N'TABLE', 
		@level1name=N'ServerLog', 
		@level2type=N'COLUMN', 
		@level2name=N'LogicalOperationStack'