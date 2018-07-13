use Transport
go

create procedure PR_Declare_Admin
@username varchar(100)
as begin

	declare @licencenumber varchar(100)

	-- da li postoji user?
	if not exists (select * from MyUser where Username = @username) return 2

	-- da li je vec admin?
	if exists (select * from Administrator where Username = @username) return 1

	insert into Administrator(Username) values (@username)

	return 0

end

go