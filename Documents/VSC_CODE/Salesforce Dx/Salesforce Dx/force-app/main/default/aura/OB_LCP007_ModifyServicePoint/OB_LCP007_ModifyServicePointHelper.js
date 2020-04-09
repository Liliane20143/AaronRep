/**
 * Created by damian.krzyzaniak on 15.07.2019.
 */
({
    /**
    * @author Damian Krzyzaniak <damian.krzyzaniak@accenture.com>
    * @date 15/07/2019
    * @task NEXI-184
    * @description Method show toast with message
    */
    showToast: function (title, message, type)
    {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})