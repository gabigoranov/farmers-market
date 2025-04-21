using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Services.Notifications;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MarketAPI.Services.Notifications
{
    /// <summary>
    /// Implementation of <see cref="INotificationsService"/> for managing notification preferences.
    /// </summary>
    public class NotificationsService : INotificationsService
    {
        private readonly ApiContext _context;
        private readonly IMapper _mapper;

        /// <summary>
        /// Constructor which initializes the necessary dependencies.
        /// </summary>
        public NotificationsService(ApiContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        /// <inheritdoc/>
        public IEnumerable<NotificationPreferences> GetAllPreferences()
        {
            return _context.NotificationPreferences.AsEnumerable();
        }

        /// <inheritdoc/>
        public NotificationPreferences? GetPreferencesByUserId(Guid userId)
        {
            return _context.NotificationPreferences.FirstOrDefault(p => p.UserId == userId);
        }

        /// <inheritdoc/>
        public async Task<NotificationPreferences> CreatePreferencesAsync(NotificationPreferences preferences)
        {
            await _context.NotificationPreferences.AddAsync(preferences);
            await _context.SaveChangesAsync();

            return preferences;
        }

        /// <inheritdoc/>
        public async Task<NotificationPreferences?> UpdatePreferencesAsync(Guid userId, NotificationPreferences preferences)
        {
            var existing = await _context.NotificationPreferences.FirstOrDefaultAsync(p => p.UserId == userId);
            if (existing == null)
            {
                return null;
            }

            existing.ShowNotifications = preferences.ShowNotifications;
            existing.ShowPurchaseUpdateNotifications = preferences.ShowPurchaseUpdateNotifications;
            existing.ShowSuggestionNotifications = preferences.ShowSuggestionNotifications;
            existing.ShowMessageNotifications = preferences.ShowMessageNotifications;

            await _context.SaveChangesAsync();

            return existing;
        }

        /// <inheritdoc/>
        public async Task DeletePreferences(Guid userId)
        {
            var preferences = await _context.NotificationPreferences.FirstOrDefaultAsync(p => p.UserId == userId);
            if (preferences == null)
            {
                return;
            }

            _context.NotificationPreferences.Remove(preferences);
            await _context.SaveChangesAsync();

        }

        /// <inheritdoc/>
        public async Task<bool> PreferencesExistAsync(Guid userId)
        {
            return await _context.NotificationPreferences.AnyAsync(p => p.UserId == userId);
        }
    }
}