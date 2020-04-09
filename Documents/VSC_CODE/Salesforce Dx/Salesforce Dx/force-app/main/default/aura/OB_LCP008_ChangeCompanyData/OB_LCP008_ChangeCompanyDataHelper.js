/**
 * Created by adrian.dlugolecki on 09.07.2019.
 */
({
     /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 09/03/2019
    * @task NEXI-178
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