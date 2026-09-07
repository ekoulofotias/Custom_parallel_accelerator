#include <vpi_user.h>

static unsigned long total_toggles = 0;

static PLI_INT32 toggle_cb(p_cb_data cb_data) {
    (void)cb_data;
    total_toggles++;
    return 0;
}

static void attach_monitor(vpiHandle obj) {
    s_cb_data cb;
    s_vpi_time t;
    s_vpi_value v;

    t.type = vpiSuppressTime;
    v.format = vpiSuppressVal;

    cb.reason    = cbValueChange;
    cb.cb_rtn    = toggle_cb;
    cb.obj       = obj;
    cb.time      = &t;
    cb.value     = &v;
    cb.user_data = NULL;

    vpi_register_cb(&cb);
}

static void scan_scope(vpiHandle scope) {
    vpiHandle iter, item;

    iter = vpi_iterate(vpiNet, scope);
    if (iter) {
        while ((item = vpi_scan(iter)) != NULL) {
            attach_monitor(item);
        }
    }

    iter = vpi_iterate(vpiReg, scope);
    if (iter) {
        while ((item = vpi_scan(iter)) != NULL) {
            attach_monitor(item);
        }
    }

    iter = vpi_iterate(vpiModule, scope);
    if (iter) {
        while ((item = vpi_scan(iter)) != NULL) {
            scan_scope(item);
        }
    }
}

static PLI_INT32 start_monitoring(p_cb_data cb_data) {
    (void)cb_data;
    vpiHandle top_iter = vpi_iterate(vpiModule, NULL);
    if (top_iter) {
        vpiHandle top_mod;
        while ((top_mod = vpi_scan(top_iter)) != NULL) {
            scan_scope(top_mod);
        }
    }
    return 0;
}

static PLI_INT32 print_activity(char *user_data) {
    (void)user_data;

    vpi_printf("SWITCHING ACTIVITY: %lu Toggles\n", total_toggles);

    return 0;
}

void register_vpi_tasks(void) {
    s_vpi_systf_data tf;

    tf.type        = vpiSysTask;
    tf.tfname      = "$print_activity";
    tf.calltf      = (PLI_INT32 (*)(char *))print_activity;
    tf.compiletf   = NULL;
    tf.sizetf      = 0;
    tf.user_data   = NULL;

    vpi_register_systf(&tf);

    s_cb_data cb;
    cb.reason    = cbStartOfSimulation;
    cb.cb_rtn    = start_monitoring;
    cb.obj       = NULL;
    cb.time      = NULL;
    cb.value     = NULL;
    cb.user_data = NULL;
    vpi_register_cb(&cb);
}

void (*vlog_startup_routines[])(void) = {
    register_vpi_tasks,
    0
};