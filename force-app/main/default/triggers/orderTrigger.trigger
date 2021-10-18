trigger orderTrigger on Order (before update, after update) {
    try {
        if(Trigger.new != null && Trigger.old != null) {
            OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
        }
    }
    catch (Exception e){

    }
}
