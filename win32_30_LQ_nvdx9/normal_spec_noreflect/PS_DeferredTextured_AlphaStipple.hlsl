sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c199);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float4 specMapExpMask : register(c198);
float3 specMapIntMask : register(c197);
float specularFactor : register(c196);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float2 vpos : VPOS;
};

struct PS_OUT
{
	float4 color2 : COLOR2;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r1.x = r0.w * globalScalars.x;
	r1.yz = 0.5 * i.vpos.xy;
	r1.yz = frac(abs(r1.yz));
	r1.yz = (i.vpos.xy >= 0) ? r1.yz : -r1.yz;
	r1.yz = r1.yz + r1.yz;
	r2.xy = frac(r1.yz);
	r1.yz = r1.yz + -r2.xy;
	r1.y = r1.z * 2 + r1.y;
	r2 = r1.y + float4(-0, -1, -2, -3);
	r2 = (-abs(r2) >= 0) ? 1 : 0;
	r1.y = dot(stipplePattern, r2);
	r0.w = r0.w * -globalScalars.x + r1.y;
	r2 = (r0.w >= 0) ? -1 : -0;
	clip(r2);
	r2 = tex2D(BumpSampler, i.texcoord.xy);
	r0.w = -r2.w + 1;
	r0.w = -r2.x + r0.w;
	r1.yz = (r0.ww >= 0) ? r2.wy : r2.xy;
	r1.yz = r1.yz * 2 + -1;
	r1.yz = r1.yz * bumpiness.xx;
	r0.w = dot(r1.yz, -r1.yz) + 1;
	r1.w = max(r0.w, 0);
	r0.w = rsqrt(r1.w);
	r0.w = 1 / r0.w;
	r2 = tex2D(SpecSampler, i.texcoord.xy);
	r1.w = dot(r2, specMapExpMask);
	r2.w = r1.w * specularFactor.x;
	o.color2.x = dot(r2.xyz, specMapIntMask.xyz);
	r3.zw = float2(1, 0);
	r1.w = r1.w * -specularFactor.x + r3.z;
	r2.xyz = r1.yyy * i.texcoord4.xyz;
	r2.xyz = r0.www * i.texcoord1.xyz + r2.xyz;
	r2.xyz = r1.zzz * i.texcoord5.xyz + r2.xyz;
	r2.xyz = r2.xyz + 1E-05;
	r4 = normalize(r2.xyz);
	r0.w = saturate(-1 + i.color.x);
	o.color.xyz = r0.www * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r4.xyz * 0.5 + 0.5;
	r0.x = saturate(r2.w * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r1.w >= 0) ? 0.26726124 : r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.w = r1.x;
	o.color3 = r3.wwwz * gStencil.x;

	return o;
}
