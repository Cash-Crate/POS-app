from django.db import models

# Create your models here.


class Users(models.Model):
    user_id = models.AutoField(primary_key=True)
    user_name = models.TextField()
    user_email = models.TextField()
    user_pass = models.TextField()
    birthdate = models.DateField()
    address = models.TextField()
    phone_num = models.TextField()
    role = models.TextField()

    class Meta:
        db_table = "users"
        managed = False

    def __str__(self):
        return f"User ID: {self.user_id},\
        User Name: {self.user_name},\
        User Email: {self.user_email},\
        User Password: {self.user_pass},\
        Birthdate: {self.birthdate},\
        Address: {self.address},\
        Phone Number: {self.phone_num},\
        Role: {self.role}"


class LoginsLoggin(models.Model):
    login_id = models.AutoField(primary_key=True)
    user_id = models.ForeignKey("Users",
                                on_delete=models.CASCADE,
                                db_column="user_id")
    login_at = models.DateTimeField(auto_now_add=True)
    logout_at = models.DateTimeField(null=True, blank=True)
    ip_address = models.GenericIPAddressField(db_column="ip_addr")
    device_type = models.TextField()
    browser = models.TextField()
    cpu_arch = models.TextField()
    host = models.TextField()
    origin = models.TextField()

    class Meta:
        db_table = "logins_logging"
        managed = False

    def __str__(self):
        return f"Login ID: {self.login_id},\
        User ID: {self.user_id},\
        Login At: {self.login_at},\
        Logout At: {self.logout_at},\
        IP Address: {self.ip_address},\
        Device Type: {self.device_type},\
        Browser: {self.browser},\
        CPU Arch: {self.cpu_arch},\
        Host: {self.host},\
        Origin: {self.origin}"


class CrudLogging(models.Model):
    action_id = models.AutoField(primary_key=True)
    user_id = models.IntegerField()
    action_at = models.DateTimeField(auto_now_add=True)
    action_taken = models.TextField()
    x_requested_with = models.TextField()

    class Meta:
        db_table = "crud_logging"
        managed = False

    def __str__(self):
        return f"Action {self.action_id} by User {self.user_id}"


class ItemTypes(models.Model):
    item_type_id = models.AutoField(primary_key=True)
    item_type_name = models.TextField()

    class Meta:
        db_table = "item_types"
        managed = False

    def __str__(self):
        return f"Item Type ID: {self.item_type_id},\
        Item Type Name: {self.item_type_name}"


class Items(models.Model):
    item_id = models.AutoField(primary_key=True)
    item_name = models.TextField()
    item_desc = models.TextField(null=True, blank=True,
                                 db_column="description")
    item_type = models.ForeignKey("ItemTypes",
                                  on_delete=models.CASCADE,
                                  db_column="item_type")
    item_image = models.TextField(null=True, blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = "items"
        managed = False

    def __str__(self):
        return f"Item ID: {self.item_id},\
        Item Name: {self.item_name},\
        Item Type: {self.item_type},\
        Item Image: {self.item_image},\
        Item Price: {self.price}"


class ItemAttributes(models.Model):
    item_type = models.IntegerField()
    item_id = models.ForeignKey("Items", on_delete=models.CASCADE,
                                db_column="item_id")
    attr_name = models.TextField()
    attr_value = models.TextField()

    class Meta:
        db_table = "item_attributes"
        managed = False
        constraints = [
            models.UniqueConstraint(fields=["item_type", "item_id"],
                                    name="unique_item_attributes")
        ]

    def __str__(self):
        return f"Item Type: {self.item_type},\
        Item ID: {self.item},\
        Attribute Name: {self.attr_name},\
        Attribute Value: {self.attr_value}"


class OnetimeTrans(models.Model):
    trans_id = models.AutoField(primary_key=True)
    trans_date = models.DateTimeField(auto_now_add=True)
    user_id = models.ForeignKey("Users",
                                on_delete=models.CASCADE,
                                db_column="user_id",
                                null=False,
                                blank=False)
    item_count = models.IntegerField()
    cost_total = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = "onetime_trans"
        managed = False

    def __str__(self):
        return f"Trans ID: {self.trans_id},\
        Trans Date: {self.trans_date},\
        User ID: {self.user_id},\
        Item Count: {self.item_count},\
        Cost Total: {self.cost_total}"


class RecurringTrans(models.Model):
    trans_id = models.AutoField(primary_key=True)
    cost_total = models.DecimalField(max_digits=10, decimal_places=2)
    item_count = models.IntegerField()
    start_date = models.DateTimeField(auto_now_add=True)
    end_date = models.DateTimeField(null=True, blank=True)
    month_fee = models.DecimalField(max_digits=10, decimal_places=2,
                                    null=True, blank=True)
    year_fee = models.DecimalField(max_digits=10, decimal_places=2,
                                   null=True, blank=True)
    user_id = models.ForeignKey("Users",
                                on_delete=models.CASCADE,
                                db_column="user_id",
                                null=False,
                                blank=False)

    class Meta:
        db_table = "recurring_trans"
        managed = False

        def __str__(self):
            return f"Trans ID: {self.trans_id},\
            Cost Total: {self.cost_total},\
            Item Count: {self.item_count},\
            Start Date: {self.start_date},\
            End Date: {self.end_date},\
            Month Fee: {self.month_fee},\
            Year Fee: {self.year_fee},\
            User ID: {self.user_id}"


class RecurringTransPayment(models.Model):
    trans_id = models.OneToOneField("RecurringTrans",
                                    on_delete=models.CASCADE,
                                    db_column="trans_id")
    payment_rcvd = models.DecimalField(max_digits=10, decimal_places=2)
    date_rcvd = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "recurring_trans_payment"
        managed = False

    def __str__(self):
        return f"Trans ID: {self.trans_id},\
        Payment Received: {self.payment_rcvd},\
        Date Received: {self.date_rcvd}"


class BoughtItems(models.Model):
    item_id = models.ForeignKey("Items",
                                on_delete=models.CASCADE,
                                db_column="item_id")
    onetime_trans_id = models.IntegerField(null=True, blank=True)
    recurring_trans_id = models.IntegerField(null=True, blank=True)
    num_item = models.IntegerField()
    items_cost = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = "bought_items"
        managed = False
        constraints = [
            models.CheckConstraint(
                check=(models.Q(onetime_trans_id__isnull=False,
                                recurring_trans_id__isnull=True) |
                       models.Q(onetime_trans_id__isnull=True,
                                recurring_trans_id__isnull=False)),
                name="check_transaction_type"
            )]

    def __str__(self):
        return f"Item: {self.item}, \
        One-time: {self.onetime_trans_id}, \
        Recurring: {self.recurring_trans_id}, \
        ItemCost: {self.items_cost}"
