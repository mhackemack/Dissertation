function [L,S_psi_psi,S_phi_psi,S_phi_phi]=compute_T1()
global snq npar mats
% dimension of the linear system
nel = npar.nel;
ndof= npar.ndof;
porder=npar.porder;
n = npar.ndof * snq.sn;
L         = spalloc(n,n,snq.sn*nel*(porder+1)^2);
S_psi_psi = spalloc(n,n,snq.sn*nel*(porder+1)^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% build the action of all transport sweeps on the scattering term
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ndir = snq.sn;
for idir=1:ndir
    m=snq.mu(idir); % shortcut
    % choose the edge contribution based on the sweeping order (L to R or R to L)
    if(m>0)
        edg=mats.elem.e{1};
    else
        edg=mats.elem.e{2};
    end

    i1 = (idir-1)*ndof+1;
    i2 = idir*ndof;

    % transport matrix for this direction
    % = mu*gradient + total mass + edge
    % note that the jacobian dx/2 is already included in the mass matrices
    % and that it does not appear in the gradient and edge matrices for 1D
    Ld = ( m*mats.elem.g + mats.elem.mt ) + m*edg;

    % one way is to build the entire SN matrix L
    % and the scattering matrix S
    L(i1:i2,i1:i2) = Ld;
    S_psi_psi(i1:i2,:) = kron(snq.w/snq.sw , mats.elem.ms);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build remaining scattering terms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_phi_phi = mats.elem.ms;
S_phi_psi = kron(ones(length(snq.w),1)/snq.sw, mats.elem.ms);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%