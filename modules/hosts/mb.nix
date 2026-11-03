{ den, ... }:
{
  den.hosts.aarch64-darwin = {
    loki.users.liexner = { };
    odin.users.liexner = { };
  };

  # shared by all macs
  den.aspects.macbook.darwin = {
    system.defaults.dock.autohide = true;
    system.defaults.finder = {
      ShowStatusBar = true; # shows "X GB available" at bottom of windows
      ShowPathbar = true;
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      _FXSortFoldersFirst = true;
      FXDefaultSearchScope = "SCcf"; # search current folder
      FXEnableExtensionChangeWarning = false;
      NewWindowTarget = "Home";
      _FXShowPosixPathInTitle = true;
    };

    # no .DS_Store on network shares / USB drives
    system.defaults.CustomUserPreferences."com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };

    homebrew = {
      enable = true;
      casks = [ "vorssaint" "wowup-cf" ];
    };
  };

  den.aspects.loki.includes = [ den.aspects.macbook ];
  den.aspects.odin.includes = [ den.aspects.macbook ];
}
