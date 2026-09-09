# Odoo Warehouse Management System

A complete warehouse management system for charitable organizations with 5 users.

## Features

- **Inventory Management**: Track stock levels, movements, and valuations
- **Purchase Management**: Manage purchase orders and supplier relationships
- **Sales Management**: Handle sales orders and customer relationships
- **Accounting Integration**: Track financial transactions
- **Reporting**: Generate comprehensive reports

## System Requirements

- **Platform**: Render.com (Free Tier)
- **Database**: PostgreSQL (Free Tier)
- **Storage**: 1GB (included)
- **Users**: 5 concurrent users

## Installation

1. Fork or clone this repository
2. Create a Render account at https://render.com
3. Create a new Blueprint from this repository
4. Wait for deployment to complete
5. Access your Odoo instance

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

Daily backups are automatically created at 2:00 AM UTC.

To manually backup:
```bash
./scripts/backup.sh
```

To restore from backup:
```bash
./scripts/restore.sh /path/to/backup.sql.gz
```

## Monitoring

Health checks run every 5 minutes. Alerts are sent when:
- CPU usage exceeds 80%
- Memory usage exceeds 80%
- Disk usage exceeds 80%
- Database connections exceed 100

## Support

For issues or questions, please refer to the SETUP-GUIDE.md file.

## License

This project is open source and available for use by charitable organizations.
