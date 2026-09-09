# Odoo Warehouse Management System

A complete warehouse management system for charitable organizations with 5 users.

## Features

- **Inventory Management**: Track stock levels, movements, and valuations
- **Purchase Management**: Manage purchase orders and supplier relationships
- **Sales Management**: Handle sales orders and customer relationships
- **Accounting Integration**: Track financial transactions
- **Reporting**: Generate comprehensive reports
- **Backup**: Automatic daily backups to Google Drive
- **Monitoring**: Real-time system health monitoring
- **Alerts**: Slack notifications for important events
- **Free Domain**: DuckDNS integration for custom domain

## System Requirements

- **Platform**: Render.com (Free Tier)
- **Database**: PostgreSQL (Free Tier)
- **Storage**: 1GB (included)
- **Users**: 5 concurrent users

## Installation

### Quick Start

1. Fork or clone this repository
2. Create a Render account at https://render.com
3. Create a new Blueprint from this repository
4. Wait for deployment to complete
5. Access your Odoo instance

### Complete Setup

```bash
# Run the complete setup script
bash scripts/complete-setup.sh
```

This will guide you through:
- Setting up DuckDNS domain
- Configuring Slack alerts
- Setting up Google Drive backup
- Configuring monitoring
- Setting up scheduled tasks

## Default Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@example.com | admin |
| Warehouse Manager | warehouse_manager | warehouse123 |
| Purchase Officer | purchase_officer | purchase123 |
| Sales Officer | sales_officer | sales123 |
| Accountant | accountant | account123 |
| Field Representative | field_rep | field123 |

## Configuration

### Users
- Warehouse Manager: Full inventory access
- Purchase Officer: Purchase order management
- Sales Officer: Sales order management
- Accountant: Financial reporting
- Field Representative: Limited access for field operations

### Warehouses
- Main Warehouse (WH-MAIN): Central storage
- Purchase Warehouse (WH-PURCH): Incoming goods
- Sales Warehouse (WH-SALES): Outgoing goods

## Backup

### Automatic Backup
Daily backups are automatically created at 2:00 AM UTC and uploaded to Google Drive.

### Manual Backup
```bash
# Backup to Google Drive
/tmp/gdrive_backup.sh

# Backup to local file
./scripts/backup.sh
```

### Restore from Backup
```bash
# Restore from Google Drive
/tmp/gdrive_restore.sh

# Restore from local file
./scripts/restore.sh /path/to/backup.sql.gz
```

## Monitoring

Health checks run every 5 minutes. Alerts are sent when:
- CPU usage exceeds 80%
- Memory usage exceeds 80%
- Disk usage exceeds 80%
- Database connections exceed 100

### Manual Health Check
```bash
/tmp/odoo_health_check.sh
```

### Performance Report
```bash
/tmp/odoo_performance_report.sh
```

## Domain Setup

### Free Domain (DuckDNS)
```bash
bash scripts/setup-domain.sh
```

This will:
1. Guide you through DuckDNS account creation
2. Configure your domain
3. Set up automatic IP updates

### Custom Domain
If you have your own domain, you can use Certbot for SSL:
```bash
bash scripts/setup-ssl.sh
```

## Alerts

### Slack Alerts
```bash
bash scripts/setup-slack.sh
```

This will:
1. Guide you through Slack workspace creation
2. Configure incoming webhooks
3. Set up alert notifications

### Test Alerts
```bash
/tmp/test_slack.sh
```

## Scheduled Tasks

The following tasks are automatically scheduled:

| Task | Schedule | Description |
|------|----------|-------------|
| Backup | Daily 2:00 AM | Backup database to Google Drive |
| Health Check | Every 5 minutes | Monitor system health |
| Performance Report | Daily 6:00 AM | Generate performance metrics |
| Domain Update | Every 5 minutes | Update DuckDNS IP address |

## File Structure

```
odoo-warehouse/
├── .gitignore              # Git ignore file
├── Dockerfile              # Docker configuration
├── render.yaml             # Render deployment config
├── README.md               # This file
├── SETUP-GUIDE.md          # Detailed setup guide
└── scripts/
    ├── init-odoo.sh        # Initialize Odoo
    ├── setup-users.xml     # User configuration
    ├── warehouse-config.xml # Warehouse configuration
    ├── setup-reports.xml   # Reports configuration
    ├── backup.sh           # Backup script
    ├── restore.sh          # Restore script
    ├── monitor.sh          # Monitoring script
    ├── setup-odoo.py       # Odoo setup script
    ├── setup-backup.py     # Backup setup
    ├── setup-domain.py     # Domain setup
    ├── setup-monitoring.py # Monitoring setup
    ├── setup-domain.sh     # DuckDNS setup
    ├── setup-slack.sh      # Slack setup
    ├── setup-gdrive.sh     # Google Drive setup
    ├── complete-setup.sh   # Complete setup script
    └── final-setup.sh      # Final setup script
```

## Troubleshooting

### Odoo Not Starting
1. Check Render logs
2. Verify database connection
3. Check disk space

### Database Connection Issues
1. Verify PostgreSQL is running
2. Check credentials in environment variables
3. Ensure database exists

### Backup Failures
1. Check Google Drive credentials
2. Verify rclone configuration
3. Check disk space

## Support

For issues or questions, please:
1. Check the SETUP-GUIDE.md file
2. Review Render logs
3. Check system health: `/tmp/odoo_health_check.sh`

## License

This project is open source and available for use by charitable organizations.

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
