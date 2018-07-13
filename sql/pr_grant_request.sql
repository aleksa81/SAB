use Transport
go

create procedure PR_Grant_Request
@username varchar(100)
as begin

	declare @licencenumber varchar(100)

	-- da li postoji request?
	if not exists (select * from Request where Username = @username) return 0

	select @licencenumber = LicenceNumber from Request where Username = @username

	begin transaction [Tran1]
	begin try

		insert into Courier(Username, DeliveredPackages, Profit, Status) values (@username, 0,0,0)
	
		insert into Drives(Username, LicenceNumber) values (@username, @licencenumber)

		delete from Request where Username = @username

	commit transaction [Tran1]
	end try
	begin catch
		rollback transaction [Tran1]
		return 0
	end catch

	return 1
end

go