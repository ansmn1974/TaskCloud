"""
Management command to delete tasks older than 1 hour.

This command should be run periodically via cron to automatically
clean up expired tasks from the database.

Usage:
    python manage.py cleanup_expired_tasks
"""
from django.core.management.base import BaseCommand
from django.utils import timezone
from datetime import timedelta
from tasks.models import Task


class Command(BaseCommand):
    help = 'Deletes tasks that are older than 1 hour'

    def add_arguments(self, parser):
        parser.add_argument(
            '--dry-run',
            action='store_true',
            help='Show what would be deleted without actually deleting',
        )

    def handle(self, *args, **options):
        # Calculate the cutoff time (1 hour ago)
        cutoff_time = timezone.now() - timedelta(hours=1)
        
        # Find tasks older than 1 hour
        expired_tasks = Task.objects.filter(created_at__lt=cutoff_time)
        count = expired_tasks.count()
        
        if options['dry_run']:
            self.stdout.write(
                self.style.WARNING(
                    f'DRY RUN: Would delete {count} tasks older than 1 hour'
                )
            )
            if count > 0:
                self.stdout.write('Tasks that would be deleted:')
                for task in expired_tasks[:10]:  # Show first 10
                    age_minutes = (timezone.now() - task.created_at).total_seconds() / 60
                    self.stdout.write(
                        f'  - {task.title} (created {age_minutes:.0f} minutes ago)'
                    )
                if count > 10:
                    self.stdout.write(f'  ... and {count - 10} more')
        else:
            # Delete expired tasks
            expired_tasks.delete()
            self.stdout.write(
                self.style.SUCCESS(
                    f'Successfully deleted {count} expired tasks'
                )
            )
