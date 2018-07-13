use Transport
go

create procedure PR_Insert_Offer
@courierUsername varchar(100),
@packageId int,
@percentage decimal(10,3)
as begin
	
	-- kurir ne sme biti u voznji
	if not exists(select * from Courier where Username = @courierUsername and Status = 0) return -1

	begin transaction [Tran1]
	begin try

		insert into Offer(Username, IdPackage, Percentage) values (@courierUsername, @packageId, @percentage)

	commit transaction [Tran1]
	end try
	begin catch
		rollback transaction [Tran1]
		return -1
	end catch

	return SCOPE_IDENTITY() 

end

go
