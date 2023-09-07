default: format (deploy "vm") (deploy "pai") (deploy "xiaobai")

format:
    alejandra '{{ justfile_directory() }}'

@get_hardware_configuration machine:
    export ADDRESS=$(jq -r '.machines.{{ machine }}.user + "@" + .machines.{{ machine }}.host' config.json) && \
    export FROM="$ADDRESS:/etc/nixos/hardware-configuration.nix" && \
    export TO='{{ justfile_directory() }}/{{ machine }}/hardware.nix' && \
    if test -f $TO; then \
        echo "Hardware configuration already exists at $TO."; \
    else \
        echo "Copying hardware configuration from $FROM to $TO." && \
        scp $FROM $TO && \
        alejandra $TO; \
    fi

@deploy machine: (get_hardware_configuration machine)
    export ADDRESS=$(jq -r '.machines.{{ machine }}.user + "@" + .machines.{{ machine }}.host' config.json) && \
    echo "Deploying to {{ machine }} on $ADDRESS" && \
    nix run nixpkgs#nixos-rebuild -- switch \
        --fast \
        --use-remote-sudo \
        --target-host $ADDRESS \
        --build-host $ADDRESS \
        --flake '.#{{ machine }}'
