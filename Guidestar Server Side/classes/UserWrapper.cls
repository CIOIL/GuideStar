public class UserWrapper{
	public string Id  {get; set;}
    public string Name  {get; set;}
    public string FirstName  {get; set;}
    public string LastName  {get; set;}
    public string EBOX_Company_Name  {get; set;}
    public string Email  {get; set;}
    public string Phone  {get; set;}
    public string Street  {get; set;}
    public string City  {get; set;}
    public string Country  {get; set;}
    public string PostalCode  {get; set;}
    public string LanguageLocaleKey {get;set;}
    public string SupplierName {get;set;}
    public string SupplierId {get;set;}

    public UserWrapper(User user){
    	Id = user.Id;
		Name = user.Name;
		FirstName = user.FirstName;
		LastName = user.LastName;
		EBOX_Company_Name = user.c;
		Email = user.Email;
		Phone = user.Phone;
		Street = user.Street;
		City = user.City;
		Country = user.Country;
		PostalCode = user.PostalCode;
        LanguageLocaleKey = user.LanguageLocaleKey;
    }
}