using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly ApiContext _context;

        public UsersController(ApiContext context)
        {
            _context = context;
        }


        [HttpGet]
        [Route("login")]
        public IActionResult Login(string email, string password)
        {
            int? discriminator = _context.Users.FirstOrDefault(u => u.Email == email && u.Password == password)?.Discriminator;
            if (discriminator != null)
            {
                if (discriminator == 1)
                {
                    Seller? user = _context.Sellers.Include(x => x.Offers).Include(x => x.SoldOrders).FirstOrDefault(u => u.Email == email && u.Password == password);
                    return Ok(user);
                }
                else if(discriminator == 0)
                {
                    User? user = _context.Users.Include(x => x.BoughtPurchases).Include(x => x.BoughtOrders).FirstOrDefault(u => u.Email == email && u.Password == password);
                    return Ok(user);
                }
                else if (discriminator == 2)
                {
                    Organization? user = _context.Organizations.Include(x => x.BoughtOrders).FirstOrDefault(u => u.Email == email && u.Password == password);
                    return Ok(user);
                }
            }

            return BadRequest("User with data doesn't exist");
        }

        [HttpGet]
        [Route("getWithId")]
        public IActionResult getWithId(Guid id)
        {
            int? discriminator = _context.Users.FirstOrDefault(u => u.Id == id)?.Discriminator;
            if (discriminator != null)
            {
                if (discriminator == 1)
                {
                    Seller? user = _context.Sellers.Include(x => x.Offers).Include(x => x.SoldOrders).FirstOrDefault(u => u.Id == id);
                    return Ok(user);
                }
                else if (discriminator == 0)
                {
                    User? user = _context.Users.Include(x => x.BoughtOrders).FirstOrDefault(u => u.Id == id);
                    return Ok(user);
                }
                else if (discriminator == 2)
                {
                    Organization? user = _context.Organizations.Include(x => x.BoughtOrders).FirstOrDefault(u => u.Id == id);
                    return Ok(user);
                }
            }

            return BadRequest("User with id doesn't exist");
        }

        [HttpPost]
        [Route("add")]
        public IActionResult AddUser(AddUserViewModel user)
        {
            if (!_context.Users.Any(u => u.Email == user.Email))
            {
                if(user.Discriminator == 0)
                {
                    _context.Users.Add(new User() //
                    {
                        FirstName = user.FirstName,
                        LastName = user.LastName,
                        Email = user.Email,
                        PhoneNumber = user.PhoneNumber,
                        Age = user.Age,
                        Description = user.Description,
                        Password = user.Password,
                        Town = user.Town,
                        Discriminator = user.Discriminator,
                    });
                }
                else if(user.Discriminator == 1)
                {
                    _context.Sellers.Add(new Seller() //
                    {
                        FirstName = user.FirstName,
                        LastName = user.LastName,
                        Email = user.Email,
                        PhoneNumber = user.PhoneNumber,
                        Age = user.Age,
                        Description = user.Description,
                        Password = user.Password,
                        Town = user.Town,
                        Discriminator = user.Discriminator,
                    });
                }
                else if(user.Discriminator == 2)
                {
                    Organization organization = new Organization()
                    {
                        Email = user.Email,
                        PhoneNumber = user.PhoneNumber,
                        Description = user.Description,
                        Password = user.Password,
                        Town = user.Town,
                        Discriminator = user.Discriminator,
                        OrganizationName = user.OrganizationName!
                    };

                    _context.Organizations.Add(organization);
                }
                _context.SaveChanges();
                string name = user.Discriminator! != 2 ? user.FirstName! : user.OrganizationName!;
                return Ok($"User: {name} added to Database");
            }
            else
            {
                return BadRequest("User with email already in Database");
            }
        }

        [HttpPost]
        [Route("edit")]
        public async Task<IActionResult> EditUser(AddUserViewModel userEdit)
        {
            if(!ModelState.IsValid)
            {
                return BadRequest(userEdit);
            }

            if(userEdit.Discriminator == 0)
            {
                User user = await _context.Users.SingleAsync(x => x.Id == userEdit.Id);
                _context.Update(user);

                user.Age = userEdit.Age;
                user.PhoneNumber = userEdit.PhoneNumber;
                user.Email = userEdit.Email;
                user.FirstName = userEdit.FirstName;
                user.LastName = userEdit.LastName;
                user.Description = userEdit.Description; 
                user.Town = userEdit.Town;
                user.Password = userEdit.Password;
                _context.Entry(user).State = EntityState.Modified;

            }
            else if(userEdit.Discriminator == 1)
            {
                Seller user = await _context.Sellers.SingleAsync(x => x.Id == userEdit.Id);
                _context.Update(user);

                user.Age = userEdit.Age;
                user.PhoneNumber = userEdit.PhoneNumber;
                user.Email = userEdit.Email;
                user.FirstName = userEdit.FirstName;
                user.LastName = userEdit.LastName;
                user.Description = userEdit.Description; 
                user.Town = userEdit.Town;
                user.Password = userEdit.Password;
                _context.Entry(user).State = EntityState.Modified;

            }
            else if (userEdit.Discriminator == 2)
            {
                Organization user = await _context.Organizations.SingleAsync(x => x.Id == userEdit.Id);
                _context.Update(user);

                user.PhoneNumber = userEdit.PhoneNumber;
                user.Email = userEdit.Email;
                user.Description = userEdit.Description; 
                user.Town = userEdit.Town;
                user.Password = userEdit.Password;
                user.OrganizationName = userEdit.OrganizationName!;
                _context.Entry(user).State = EntityState.Modified;

            }

            _context.SaveChanges();

            return Ok("Edited Succesfully");    
        }

        [HttpPost]
        [Route("setFirebaseToken")]
        public async Task<IActionResult> SetFirebaseToken(Guid id, string token)
        {

            User? user = await _context.Users.SingleOrDefaultAsync(x => x.Id == id);
            if (user == null)
            {
                return NotFound("User does not exist");
            }

            _context.Update(user);

            user.FirebaseToken = token;

            _context.Entry(user).State = EntityState.Modified;
            _context.SaveChanges();

            return Ok("Edited Succesfully");
        }

        [HttpDelete]
        [Route("delete")]
        public async Task<IActionResult> DeleteUser(Guid id)
        {
            if (!_context.Users.Any(x => x.Id == id)) return BadRequest("Invalid Id");    
            var user = await _context.Users.SingleAsync(x => x.Id == id);
            _context.Users.Remove(user);

            await _context.SaveChangesAsync();

            return Ok("Deleted Succesfully");
        }

        [HttpGet]
        [Route("history")]
        public async Task<IActionResult> History(Guid id)
        {
            if (!_context.Users.Any(x => x.Id == id)) return BadRequest("Invalid Id");
            var user = await _context.Users.Include(x =>x.BoughtPurchases).ThenInclude(x => x.Orders).SingleAsync(x => x.Id == id);
            return Ok(user.BoughtPurchases);
        }

    }
}
