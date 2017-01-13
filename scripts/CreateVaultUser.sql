USE [master]

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'vault')
BEGIN
	CREATE LOGIN vault WITH PASSWORD = 'Str0ng!Passw0rd'
	CREATE USER vault FOR LOGIN vault
	END
GO

-- Because entity framework needs dbcreator permissions we have to make vault a sysadmin...!
-- If vault was not granting dbcreator we would use a much less privileged role
ALTER SERVER ROLE sysadmin ADD MEMBER [vault]
GO

SELECT name, create_date FROM sys.database_principals WHERE name = N'vault'
GO
