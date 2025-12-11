import { Role } from '@/enums/Role'
import { usePage } from '@inertiajs/vue3'
import { computed } from 'vue'

export function usePermissions() {
  const page = usePage()
  const roles = computed<string[]>(() => page.props.auth.roles || [])
  const permissions = computed<string[]>(
    () => page.props.auth.permissions || []
  )

  const hasPermission = (permission: string) => {
    if (permission.includes('|')) {
      return permission
        .split('|')
        .some((p) => permissions.value.includes(p.trim()))
    }

    return permissions.value.includes(permission)
  }

  const hasRole = (role: string) => {
    if (role.includes('|')) {
      return role.split('|').some((r) => roles.value.includes(r.trim()))
    }

    return roles.value.includes(role)
  }

  const hasAnyRole = (rolesToCheck: string[]) =>
    rolesToCheck.some((role) => hasRole(role))

  const isAdmin = computed(() => hasRole(Role.ADMIN))
  const isManager = computed(() => hasRole(Role.MANAGER))
  const isUser = computed(() => hasRole(Role.USER))

  return {
    hasPermission,
    hasRole,
    hasAnyRole,
    isAdmin,
    isManager,
    isUser
  }
}
