OTAB_FILES_WITH_VARIABLES ?= ""

insert_otab_variables() {
  for file in ${OTAB_FILES_WITH_VARIABLES}; do
    if [ -f "$file" ]; then
      sed -e "s@<OTAB_ROOTFS_IMAGE_NAME>@${OTAB_ROOTFS_IMAGE_NAME}@g" -i ${file}
      sed -e "s@<OTAB_ROOTFS_IMAGE_FSTYPE>@${OTAB_ROOTFS_IMAGE_FSTYPE}@g" -i ${file}
      sed -e "s@<OTAB_ROOTFS_A_IMAGE_FSTYPE>@${OTAB_ROOTFS_A_IMAGE_FSTYPE}@g" -i ${file}
      sed -e "s@<OTAB_ROOTFS_SEARCH_PATH>@${OTAB_ROOTFS_SEARCH_PATH}@g" -i ${file}
      sed -e "s@<OTAB_STORAGE_DEVICE>@${OTAB_STORAGE_DEVICE}@g" -i ${file}
      sed -e "s@<OTAB_DEVICE_MAIN>@${OTAB_DEVICE_MAIN}@g" -i ${file}
      sed -e "s@<OTAB_DEVICE_BOOT>@${OTAB_DEVICE_BOOT}@g" -i ${file}
      sed -e "s@<OTAB_DEVICE_BOOT_A>@${OTAB_DEVICE_BOOT_A}@g" -i ${file}
      sed -e "s@<OTAB_BOOT_A_IMAGE_FSTYPE>@${OTAB_BOOT_A_IMAGE_FSTYPE}@g" -i ${file}
      sed -e "s@<OTAB_DEVICE_BOOT_B>@${OTAB_DEVICE_BOOT_B}@g" -i ${file}
      sed -e "s@<OTAB_DEVICE_ROOTFS_A>@${OTAB_DEVICE_ROOTFS_A}@g" -i ${file}
      sed -e "s@<OTAB_DEVICE_ROOTFS_B>@${OTAB_DEVICE_ROOTFS_B}@g" -i ${file}
      sed -e "s@<OTAB_LABEL_BOOT>@${OTAB_LABEL_BOOT}@g" -i ${file}
      sed -e "s@<OTAB_LABEL_BOOT_A>@${OTAB_LABEL_BOOT_A}@g" -i ${file}
      sed -e "s@<OTAB_LABEL_BOOT_B>@${OTAB_LABEL_BOOT_B}@g" -i ${file}
      sed -e "s@<OTAB_LABEL_ROOTFS_A>@${OTAB_LABEL_ROOTFS_A}@g" -i ${file}
      sed -e "s@<OTAB_LABEL_ROOTFS_B>@${OTAB_LABEL_ROOTFS_B}@g" -i ${file}
      sed -e "s@<OTAB_LABEL_DATA>@${OTAB_LABEL_DATA}@g" -i ${file}
      sed -e "s@<OTAB_LABEL_ROOTFS_OVERLAY>@${OTAB_LABEL_ROOTFS_OVERLAY}@g" -i ${file}
      sed -e "s@<OTAB_BOOT_PART_SIZE>@${OTAB_BOOT_PART_SIZE}@g" -i ${file}
      sed -e "s@<OTAB_ROOTFS_PART_SIZE>@${OTAB_ROOTFS_PART_SIZE}@g" -i ${file}
      sed -e "s@<OTAB_DATA_PART_SIZE>@${OTAB_DATA_PART_SIZE}@g" -i ${file}
      sed -e "s@<OTAB_KERNEL_IMAGE_TYPE>@${OTAB_KERNEL_IMAGE_TYPE}@g" -i ${file}
      sed -e "s@<OTAB_KERNEL_IMAGE_EXTENSION>@${OTAB_KERNEL_IMAGE_EXTENSION}@g" -i ${file}
      sed -e "s@<OTAB_KERNEL_IMAGE_A>@${OTAB_KERNEL_IMAGE_A}@g" -i ${file}
      sed -e "s@<OTAB_KERNEL_IMAGE_B>@${OTAB_KERNEL_IMAGE_B}@g" -i ${file}
      sed -e "s@<OTAB_PASS_PROTECT>@${OTAB_PASS_PROTECT}@g" -i ${file}
      sed -e "s@<OTAB_HTTP_USER>@${OTAB_HTTP_USER}@g" -i ${file}
      sed -e "s@<OTAB_HTTP_PASSWORD>@${OTAB_HTTP_PASSWORD}@g" -i ${file}
      sed -e "s@<OTAB_BUCKET_DEBUG>@${OTAB_BUCKET_DEBUG}@g" -i ${file}
      sed -e "s@<OTAB_BUCKET_PROD>@${OTAB_BUCKET_PROD}@g" -i ${file}
      sed -e "s@<OTAB_UPDATE_SLOT_START>@${OTAB_UPDATE_SLOT_START}@g" -i ${file}
      sed -e "s@<OTAB_UPDATE_SLOT_STOP>@${OTAB_UPDATE_SLOT_STOP}@g" -i ${file}
      sed -e "s@<OTAB_SERVER_LINK>@${OTAB_SERVER_LINK}@g" -i ${file}
      sed -e "s@<OTAB_SIGNED_IMAGE>@${OTAB_SIGNED_IMAGE}@g" -i ${file}
      sed -e "s@<OTAB_ENCRYPTED_IMAGE>@${OTAB_ENCRYPTED_IMAGE}@g" -i ${file}
      sed -e "s@<OTAB_KEYS_DIR>@${OTAB_KEYS_DIR}@g" -i ${file}
      sed -e "s@<OTAB_SIG_CERT>@${OTAB_SIG_CERT}@g" -i ${file}
      sed -e "s@<OTAB_ENC_KEY>@${OTAB_ENC_KEY}@g" -i ${file}
      sed -e "s@<OTAB_RESET_OVERLAY>@${OTAB_RESET_OVERLAY}@g" -i ${file}
      sed -e "s@<MACHINE>@${MACHINE}@g" -i ${file}
      sed -e "s@<OTAB_UPDATE_DAYS>@${OTAB_UPDATE_DAYS}@g" -i ${file}
      sed -e "s@<OTAB_UPDATE_POLL_INTERVAL>@${OTAB_UPDATE_POLL_INTERVAL}@g" -i ${file}
      sed -e "s@<OTAB_TIME_SLOT_CHECK_INTERVAL>@${OTAB_TIME_SLOT_CHECK_INTERVAL}@g" -i ${file}
      sed -e "s@<OTAB_UPDATE_POLL_MAX>@${OTAB_UPDATE_POLL_MAX}@g" -i ${file}
      sed -e "s@<BOOT_UUID>@${BOOT_UUID}@g" -i "${file}"
      sed -e "s@<ROOT_UUID>@${ROOT_UUID}@g" -i "${file}"
      sed -e "s@<BOOT_A_UUID>@${BOOT_A_UUID}@g" -i "${file}"
      sed -e "s@<BOOT_B_UUID>@${BOOT_B_UUID}@g" -i "${file}"
      sed -e "s@<ROOT_A_UUID>@${ROOT_A_UUID}@g" -i "${file}"
      sed -e "s@<ROOT_B_UUID>@${ROOT_B_UUID}@g" -i "${file}"
      sed -e "s@<BOOT_TMP_UUID>@${BOOT_TMP_UUID}@g" -i "${file}"
      sed -e "s@<ROOT_TMP_UUID>@${ROOT_TMP_UUID}@g" -i "${file}"
      sed -e "s@<BOOT_TMP_LABEL>@${BOOT_TMP_LABEL}@g" -i "${file}"
      sed -e "s@<ROOT_TMP_LABEL>@${ROOT_TMP_LABEL}@g" -i "${file}"
    fi
  done
}
